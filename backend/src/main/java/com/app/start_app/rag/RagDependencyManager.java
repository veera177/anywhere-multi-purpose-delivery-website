package com.app.start_app.rag;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

/** Starts local RAG dependencies when needed, without taking ownership of an
 * Ollama or Chroma process that was already running. */
@Component("ragDependencyManager")
public class RagDependencyManager {
    private static final Logger log = LoggerFactory.getLogger(RagDependencyManager.class);
    private static final Duration HTTP_TIMEOUT = Duration.ofSeconds(2);

    private final boolean autoStart;
    private final String chromaUrl;
    private final String ollamaBaseUrl;
    private final String pythonExecutable;
    private final String ollamaExecutable;
    private final String chromaScript;
    private final boolean ollamaCpuOnly;
    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(HTTP_TIMEOUT)
            .build();
    private final List<Process> ownedProcesses = new ArrayList<>();

    public RagDependencyManager(
            @Value("${rag.auto-start:true}") boolean autoStart,
            @Value("${chroma.url:http://127.0.0.1:8000}") String chromaUrl,
            @Value("${ollama.base.url:http://127.0.0.1:11434}") String ollamaBaseUrl,
            @Value("${rag.python.executable:python}") String pythonExecutable,
            @Value("${rag.ollama.executable:ollama}") String ollamaExecutable,
            @Value("${rag.chroma.script:run_chroma.py}") String chromaScript,
            @Value("${rag.ollama.cpu-only:true}") boolean ollamaCpuOnly) {
        this.autoStart = autoStart;
        this.chromaUrl = trimSlash(chromaUrl);
        this.ollamaBaseUrl = trimSlash(ollamaBaseUrl);
        this.pythonExecutable = pythonExecutable;
        this.ollamaExecutable = ollamaExecutable;
        this.chromaScript = chromaScript;
        this.ollamaCpuOnly = ollamaCpuOnly;
    }

    @PostConstruct
    public void startDependencies() {
        if (!autoStart) {
            log.info("RAG dependency auto-start is disabled.");
            return;
        }

        ensureService("Ollama", this::ollamaHealthy, this::startOllama);
        ensureService("ChromaDB", this::chromaHealthy, this::startChroma);
    }

    private void ensureService(String name, HealthCheck healthCheck, ProcessStarter starter) {
        if (healthCheck.isHealthy()) {
            log.info("{} is already available.", name);
            return;
        }
        try {
            Process process = starter.start();
            if (process != null) ownedProcesses.add(process);
            if (waitUntilHealthy(healthCheck, process, Duration.ofSeconds(35))) {
                log.info("{} is ready.", name);
            } else {
                log.warn("{} did not become ready. RAG answers may be unavailable until it starts.", name);
            }
        } catch (Exception exception) {
            log.warn("Could not start {} automatically: {}", name, exception.getMessage());
        }
    }

    private boolean waitUntilHealthy(HealthCheck healthCheck, Process process, Duration timeout) {
        long deadline = System.nanoTime() + timeout.toNanos();
        while (System.nanoTime() < deadline) {
            if (healthCheck.isHealthy()) return true;
            if (process != null && !process.isAlive()) return false;
            try {
                Thread.sleep(500);
            } catch (InterruptedException exception) {
                Thread.currentThread().interrupt();
                return false;
            }
        }
        return healthCheck.isHealthy();
    }

    private boolean ollamaHealthy() {
        return httpHealthy(ollamaBaseUrl + "/api/tags");
    }

    private boolean chromaHealthy() {
        return httpHealthy(chromaUrl + "/api/v2/heartbeat");
    }

    private boolean httpHealthy(String url) {
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(url))
                    .timeout(HTTP_TIMEOUT)
                    .GET()
                    .build();
            int status = httpClient.send(request, HttpResponse.BodyHandlers.discarding()).statusCode();
            return status >= 200 && status < 300;
        } catch (Exception ignored) {
            return false;
        }
    }

    private Process startOllama() throws IOException {
        List<String> command = new ArrayList<>();
        command.add(resolveOllamaExecutable());
        command.add("serve");
        return startProcess(command, Path.of(System.getProperty("user.dir")), ollamaCpuOnly);
    }

    private Process startChroma() throws IOException {
        Path root = Path.of(System.getProperty("user.dir")).toAbsolutePath().normalize();
        Path script = root.resolve(chromaScript).normalize();
        if (!script.startsWith(root) || !Files.isRegularFile(script)) {
            throw new IOException("Chroma launcher not found at " + script + "; set rag.chroma.script to its path.");
        }

        List<String> command = pythonCommand();
        command.add(script.toString());
        return startProcess(command, root);
    }

    private List<String> pythonCommand() {
        List<String> command = new ArrayList<>();
        command.add(pythonExecutable);
        return command;
    }

    private String resolveOllamaExecutable() {
        Path configured = Path.of(ollamaExecutable);
        if (configured.isAbsolute() || ollamaExecutable.contains("\\") || ollamaExecutable.contains("/")) {
            return configured.toString();
        }
        String localAppData = System.getenv("LOCALAPPDATA");
        if (localAppData != null) {
            Path installed = Path.of(localAppData, "Programs", "Ollama", "ollama.exe");
            if (Files.isRegularFile(installed)) return installed.toString();
        }
        return ollamaExecutable;
    }

    private Process startProcess(List<String> command) throws IOException {
        return startProcess(command, Path.of(System.getProperty("user.dir")));
    }

    private Process startProcess(List<String> command, Path workingDirectory) throws IOException {
        return startProcess(command, workingDirectory, false);
    }

    private Process startProcess(List<String> command, Path workingDirectory, boolean forceOllamaCpu) throws IOException {
        ProcessBuilder builder = new ProcessBuilder(command)
                .directory(workingDirectory.toFile())
                .redirectError(ProcessBuilder.Redirect.INHERIT)
                .redirectOutput(ProcessBuilder.Redirect.INHERIT);
        if (forceOllamaCpu) {
            builder.environment().put("OLLAMA_LLM_LIBRARY", "cpu");
        }
        try {
            return builder.start();
        } catch (IOException firstFailure) {
            if (isWindows() && command.size() > 0 && command.get(0).equalsIgnoreCase(pythonExecutable)) {
                List<String> pyLauncher = new ArrayList<>(List.of("py", "-3"));
                pyLauncher.addAll(command.subList(1, command.size()));
                return new ProcessBuilder(pyLauncher)
                        .directory(workingDirectory.toFile())
                        .redirectError(ProcessBuilder.Redirect.INHERIT)
                        .redirectOutput(ProcessBuilder.Redirect.INHERIT)
                        .start();
            }
            throw firstFailure;
        }
    }

    @PreDestroy
    public void stopOwnedProcesses() {
        for (int index = ownedProcesses.size() - 1; index >= 0; index--) {
            Process process = ownedProcesses.get(index);
            if (!process.isAlive()) continue;
            process.destroy();
            try {
                if (!process.waitFor(5, TimeUnit.SECONDS)) process.destroyForcibly();
            } catch (InterruptedException exception) {
                Thread.currentThread().interrupt();
                process.destroyForcibly();
            }
        }
    }

    private static String trimSlash(String value) {
        return value == null ? "" : value.replaceAll("/+$", "");
    }

    private static boolean isWindows() {
        return System.getProperty("os.name", "").toLowerCase(Locale.ROOT).contains("win");
    }

    @FunctionalInterface
    private interface HealthCheck { boolean isHealthy(); }

    @FunctionalInterface
    private interface ProcessStarter { Process start() throws IOException; }
}
