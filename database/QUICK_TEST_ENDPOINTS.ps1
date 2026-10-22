# JWT Integration - Quick Testing Script
# This PowerShell script tests all JWT endpoints
# Run this AFTER backend is started and database is initialized

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Anywhere Delivery App - JWT Integration Tests" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$BACKEND_URL = "http://localhost:8080"
$FRONTEND_URL = "http://localhost:5173"

# Test Credentials
$EMAIL = "demo@gmail.com"
$PASSWORD = "12345"

# Color output functions
function Write-Success { Write-Host "[✓] $args" -ForegroundColor Green }
function Write-Error { Write-Host "[✗] $args" -ForegroundColor Red }
function Write-Info { Write-Host "[ℹ] $args" -ForegroundColor Blue }
function Write-Warning { Write-Host "[!] $args" -ForegroundColor Yellow }

# Test 1: Health Check
Write-Host ""
Write-Host "TEST 1: Backend Health Check" -ForegroundColor Magenta
Write-Host "============================" -ForegroundColor Magenta
try {
    $response = Invoke-WebRequest -Uri "$BACKEND_URL/actuator/health" -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Success "Backend is running on port 8080"
        $health = $response.Content | ConvertFrom-Json
        Write-Info "Health Status: $($health.status)"
        if ($health.components.db.status -eq "UP") {
            Write-Success "Database connection is ACTIVE"
        } else {
            Write-Error "Database connection FAILED"
        }
    }
} catch {
    Write-Error "Backend is not running or not responding"
    Write-Error "Solution: Start backend with: mvn spring-boot:run"
    exit 1
}

# Test 2: Database Verification
Write-Host ""
Write-Host "TEST 2: Database Verification" -ForegroundColor Magenta
Write-Host "==============================" -ForegroundColor Magenta
Write-Info "Run this SQL query to verify database setup:"
Write-Info "  USE anywhere;"
Write-Info "  SELECT COUNT(*) AS users FROM users;"
Write-Info "  SELECT COUNT(*) AS districts FROM districts;"
Write-Info "  SELECT * FROM users WHERE email = '$EMAIL';"

# Test 3: JWT Login Endpoint
Write-Host ""
Write-Host "TEST 3: JWT Login Endpoint" -ForegroundColor Magenta
Write-Host "===========================" -ForegroundColor Magenta
Write-Info "Sending login request with credentials:"
Write-Info "  Email: $EMAIL"
Write-Info "  Password: $PASSWORD"

try {
    $loginBody = @{
        email = $EMAIL
        password = $PASSWORD
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$BACKEND_URL/api/auth/login" `
        -Method POST `
        -Headers @{ "Content-Type" = "application/json" } `
        -Body $loginBody `
        -ErrorAction Stop

    if ($response.StatusCode -eq 200) {
        Write-Success "Login successful (HTTP 200)"
        
        $auth = $response.Content | ConvertFrom-Json
        
        if ($auth.token) {
            Write-Success "JWT token generated"
            Write-Info "Token (first 50 chars): $($auth.token.Substring(0, 50))..."
            Write-Info "Token expiry: 24 hours from login"
        }
        
        Write-Info "User Info Returned:"
        Write-Info "  ID: $($auth.userId)"
        Write-Info "  Name: $($auth.fullName)"
        Write-Info "  Email: $($auth.email)"
        Write-Info "  Role: $($auth.role)"
        Write-Info "  District: $($auth.district)"
        
        # Save token for next test
        $GLOBAL:JWT_TOKEN = $auth.token
        $GLOBAL:USER_ID = $auth.userId
    }
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Error "Login failed - Invalid credentials"
        Write-Error "Verify: Email = $EMAIL, Password = $PASSWORD"
    } else {
        Write-Error "Login request failed: $($_.Exception.Message)"
    }
}

# Test 4: Invalid Credentials
Write-Host ""
Write-Host "TEST 4: Invalid Credentials Test" -ForegroundColor Magenta
Write-Host "==================================" -ForegroundColor Magenta
try {
    $badLoginBody = @{
        email = "wrong@email.com"
        password = "wrongpassword"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$BACKEND_URL/api/auth/login" `
        -Method POST `
        -Headers @{ "Content-Type" = "application/json" } `
        -Body $badLoginBody `
        -ErrorAction Stop
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Success "Invalid credentials properly rejected (HTTP 401)"
    } else {
        Write-Warning "Unexpected error: $($_.Exception.Message)"
    }
}

# Test 5: Protected Endpoint with Token
Write-Host ""
Write-Host "TEST 5: Protected Endpoint Access" -ForegroundColor Magenta
Write-Host "===================================" -ForegroundColor Magenta

if ($GLOBAL:JWT_TOKEN) {
    Write-Info "Testing endpoint: GET /api/orders/user/$GLOBAL:USER_ID"
    Write-Info "Using JWT token in Authorization header"
    
    try {
        $response = Invoke-WebRequest -Uri "$BACKEND_URL/api/orders/user/$GLOBAL:USER_ID" `
            -Method GET `
            -Headers @{
                "Authorization" = "Bearer $($GLOBAL:JWT_TOKEN)"
                "Content-Type" = "application/json"
            } `
            -ErrorAction Stop

        if ($response.StatusCode -eq 200) {
            Write-Success "Protected endpoint accessible with valid JWT (HTTP 200)"
            $orders = $response.Content | ConvertFrom-Json
            Write-Info "Response: $($response.Content)"
        }
    } catch {
        if ($_.Exception.Response.StatusCode -eq 401) {
            Write-Error "JWT token rejected - may be invalid or expired"
        } elseif ($_.Exception.Response.StatusCode -eq 404) {
            Write-Success "Endpoint returned 404 (endpoint exists but no data) - JWT was validated"
        } else {
            Write-Info "Response: $($_.Exception.Response.StatusCode) - $($_.Exception.Message)"
        }
    }
} else {
    Write-Error "Cannot test protected endpoint - no JWT token from login test"
}

# Test 6: Protected Endpoint without Token
Write-Host ""
Write-Host "TEST 6: Protected Endpoint without Token" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Info "Testing endpoint: GET /api/orders/user/1 (NO Authorization header)"

try {
    $response = Invoke-WebRequest -Uri "$BACKEND_URL/api/orders/user/1" `
        -Method GET `
        -Headers @{ "Content-Type" = "application/json" } `
        -ErrorAction Stop
    
    Write-Warning "Request succeeded without token - endpoint may not be protected"
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Success "Request rejected without token (HTTP 401) - endpoint is properly protected"
    } elseif ($_.Exception.Response.StatusCode -eq 403) {
        Write-Success "Request rejected without token (HTTP 403 Forbidden) - endpoint is properly protected"
    } else {
        Write-Info "Response: $($_.Exception.Response.StatusCode)"
    }
}

# Test 7: Frontend Availability
Write-Host ""
Write-Host "TEST 7: Frontend Availability" -ForegroundColor Magenta
Write-Host "=============================" -ForegroundColor Magenta
try {
    $response = Invoke-WebRequest -Uri $FRONTEND_URL -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Success "Frontend is running on port 5173"
        Write-Info "URL: $FRONTEND_URL"
    }
} catch {
    Write-Error "Frontend is not running"
    Write-Error "Solution: Run: npm run dev (in my-react-app folder)"
}

# Summary
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "TEST SUMMARY" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Info "If all tests passed:"
Write-Info "✓ Backend is running"
Write-Info "✓ Database is initialized"
Write-Info "✓ JWT authentication is working"
Write-Info "✓ Protected endpoints require JWT"
Write-Info "✓ Frontend is accessible"
Write-Host ""
Write-Info "Next steps:"
Write-Info "1. Open browser: http://localhost:5173"
Write-Info "2. Click 'Sign In'"
Write-Info "3. Enter: Email = $EMAIL, Password = $PASSWORD"
Write-Info "4. Verify login succeeds and token is stored"
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
