# Backend Compilation & Build Guide

## Issue: Maven Wrapper Cache Corruption

The `mvnw.cmd` wrapper may have a corrupted cache causing: `Cannot load from object array because 'this.hashes' is null`

## Solution Options (Try in Order)

### Option 1: Use System Maven (Recommended)

If you have Maven installed globally on your system:

```powershell
# Navigate to backend directory
cd D:\springboot\start-app\start-app

# Clean and compile using system Maven
mvn clean package -DskipTests

# Or just compile without packaging
mvn clean compile
```

**Prerequisites:**
- Maven 3.8.1 or later installed
- Java 17 installed and in PATH
- MySQL running on localhost:3306

### Option 2: Clean Maven Wrapper Cache

If you want to use the wrapper again:

```powershell
cd D:\springboot\start-app\start-app

# Remove Maven wrapper cache
Remove-Item -Recurse -Force .mvn

# Remove build artifacts
Remove-Item -Recurse -Force target

# Re-download Maven wrapper
.\mvnw.cmd clean package -DskipTests
```

### Option 3: Use IDE Build (IntelliJ / VS Code)

If using IntelliJ IDEA or VS Code with Java extensions:

1. Open the project in IDE
2. Right-click `pom.xml` → Maven → Reload projects
3. Build → Build Project (or Ctrl+F9)

---

## Before Building - Prerequisites Checklist

✅ **Java 17 Installed**
```powershell
java -version
# Should show: java version "17.x.x"
```

✅ **MySQL Running**
```powershell
# Check if MySQL is running (port 3306)
netstat -ano | findstr :3306
```

✅ **Database Created**
```powershell
# Run the database setup script in MySQL
# Database: D:\anywhere\SETUP_DATABASE.sql
```

✅ **JWT_SECRET Environment Variable (Optional but Recommended)**
```powershell
# Set for this session (temporary)
$env:JWT_SECRET = "your-super-secret-key-min-32-chars-long-for-production"

# Or set permanently in Windows Environment Variables:
# System Properties → Environment Variables → New → 
# Variable name: JWT_SECRET
# Variable value: your-secret-key
```

---

## Build Commands

### Clean Compile (Recommended First Time)
```powershell
cd D:\springboot\start-app\start-app
mvn clean compile
```

### Full Package (With JAR creation)
```powershell
cd D:\springboot\start-app\start-app
mvn clean package -DskipTests
```

### Run Tests
```powershell
cd D:\springboot\start-app\start-app
mvn clean test
```

---

## After Successful Build - Run Backend

### Option 1: Run from JAR
```powershell
cd D:\springboot\start-app\start-app\target
java -jar start-app-0.0.1-SNAPSHOT.jar
```

### Option 2: Run via Maven
```powershell
cd D:\springboot\start-app\start-app
mvn spring-boot:run
```

### Option 3: Run via IDE
In IntelliJ: Right-click `StartAppApplication.java` → Run

---

## Verify Backend is Running

```powershell
# Check if backend is listening on port 8080
curl http://localhost:8080/actuator/health

# Should return:
# {"status":"UP","components":{"db":{"status":"UP"}}}
```

---

## Common Compilation Errors

### Error: "Cannot load from object array because 'this.hashes' is null"
- **Solution**: Use system Maven (Option 1) or clear wrapper cache (Option 2)

### Error: "Connection refused" to MySQL
- **Solution**: Start MySQL service, verify credentials in `application.properties`
- Username: `root`
- Password: `sql205071`
- Database: `anywhere`

### Error: "Invalid JWT secret"
- **Solution**: JWT_SECRET should be at least 32 characters long for HS256 algorithm
- Current default: `your-secret-key-change-in-production-env-variable` (26 chars)
- For production, use a stronger key via `JWT_SECRET` environment variable

### Error: "Class not found: JwtUtil"
- **Solution**: Ensure you're compiling from the correct backend directory:
  - Correct: `D:\springboot\start-app\start-app`
  - Incorrect: `c:\Users\veera vadivelan\OneDrive\Desktop\react\backend` (old backend)

---

## Build Output Expected

After successful build, you should see:
```
[INFO] Building start-app 0.0.1-SNAPSHOT
[INFO] ================================[ jar ]================================
[INFO] --- maven-clean-plugin:3.3.1:clean (default-clean) @ start-app ---
[INFO] --- maven-resources-plugin:3.3.1:resources (default-resources) @ start-app ---
[INFO] --- maven-compiler-plugin:3.11.0:compile (default-compile) @ start-app ---
[INFO] BUILD SUCCESS
[INFO] Total time: XX.XXXs
```

---

## Next Steps After Successful Build

1. ✅ Start the backend: `java -jar target/start-app-0.0.1-SNAPSHOT.jar`
2. ✅ Initialize database: Run `SETUP_DATABASE.sql` in MySQL
3. ✅ Test JWT login: POST http://localhost:8080/api/auth/login
4. ✅ Run frontend: `cd my-react-app && npm run dev`
5. ✅ Test end-to-end login flow

---

## Support Information

**Backend Configuration File:** `D:\springboot\start-app\start-app\src\main\resources\application.properties`

**JWT Configuration:**
- Algorithm: HS256
- Expiration: 24 hours (86400000 ms) by default
- Secret: Environment variable `JWT_SECRET` (with fallback default)

**Database:**
- Host: localhost:3306
- Database: anywhere
- User: root
- Password: sql205071 (configured in application.properties)

