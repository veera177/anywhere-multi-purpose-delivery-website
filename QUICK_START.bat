@echo off
REM Quick Start Script for Frontend Only
REM This script starts just the React frontend

echo.
echo ═══════════════════════════════════════════════════════════════
echo        Anywhere Frontend - Quick Start
echo ═══════════════════════════════════════════════════════════════
echo.

REM Check Node.js
node -version >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo Please install Node.js 14 or higher
    pause
    exit /b
)
echo ✓ Node.js found

echo.
cd /d "C:\Users\veera vadivelan\OneDrive\Desktop\react"

REM Check if node_modules exists, if not run npm install
if not exist node_modules (
    echo Installing dependencies (first time only)...
    call npm install
    if %errorLevel% neq 0 (
        echo ❌ npm install failed
        pause
        exit /b
    )
)

echo.
echo ═══════════════════════════════════════════════════════════════
echo Starting React Development Server...
echo ═══════════════════════════════════════════════════════════════
echo.
echo Frontend will be available at: http://localhost:5173
echo.
echo Make sure backend is running on http://localhost:8080
echo.

npm run dev

pause
