package com.app.start_app.config;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;

/**
 * Keeps expected API errors useful to the browser. Spring's default response
 * often exposes only "Forbidden", which leaves a customer unable to correct
 * a profile-district, stock, or ownership problem.
 */
@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<Map<String, String>> handleResponseStatus(ResponseStatusException exception) {
        String message = exception.getReason();
        if (message == null || message.isBlank()) {
            message = exception.getStatusCode().toString();
        }
        return ResponseEntity.status(exception.getStatusCode())
                .body(Map.of("error", message, "message", message));
    }
}
