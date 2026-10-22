@echo off
REM Quick Start Frontend Only

cd /d "C:\Users\veera vadivelan\OneDrive\Desktop\react"

echo.
echo ═══════════════════════════════════════════════════════════
echo        Anywhere Frontend - Starting React Dev Server
echo ═══════════════════════════════════════════════════════════
echo.

REM Check if node_modules exists
if not exist node_modules (
    echo Installing dependencies (first time only)...
    echo This may take 1-2 minutes...
    call npm install
    if %errorLevel% neq 0 (
        echo.
        echo ❌ npm install failed
        echo Please make sure Node.js is installed
        pause
        exit /b
    )
)

echo.
echo ═══════════════════════════════════════════════════════════
echo Frontend will start on: http://localhost:5173
echo ═══════════════════════════════════════════════════════════
echo.
echo Make sure backend is running on http://localhost:8080
echo.
echo Press any key to start...
pause

npm run dev

pause
