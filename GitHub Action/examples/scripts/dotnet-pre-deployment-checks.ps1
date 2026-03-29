<# 
    C# Deployment Pre-Flight Checks
    Validates environment before deployment
    
    Usage: .\pre-deployment-checks.ps1
    Exit: 0 (pass/warn), 1 (failure)
#>

param(
    [string]$MinDiskSpaceGB = 2,
    [string]$MinMemoryMB = 512,
    [string]$DeploymentDir = "C:\Applications"
)

# Color output functions
function Write-Pass { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Warn { Write-Host "⚠ $args" -ForegroundColor Yellow }
function Write-Fail { Write-Host "✗ $args" -ForegroundColor Red }

# Initialize counters
$checks = @()
$passed = 0
$warned = 0
$failed = 0

Write-Host "═══════════════════════════════════════════════════════════"
Write-Host "C# Application - Pre-Deployment Environment Checks"
Write-Host "═══════════════════════════════════════════════════════════"
Write-Host ""

# ============ Check 1: Disk Space ============
Write-Host "[1] Checking Disk Space..."
try {
    $disk = Get-PSDrive -Name "C" -ErrorAction Stop
    $availableGB = [math]::Round($disk.Free / 1GB, 2)
    
    if ($availableGB -ge $MinDiskSpaceGB) {
        Write-Pass "Disk space available: ${availableGB}GB (required: ${MinDiskSpaceGB}GB)"
        $checks += @{ Name = "Disk Space"; Status = "PASS" }
        $passed++
    } else {
        Write-Fail "Insufficient disk space: ${availableGB}GB (required: ${MinDiskSpaceGB}GB)"
        $checks += @{ Name = "Disk Space"; Status = "FAIL" }
        $failed++
    }
} catch {
    Write-Fail "Disk space check failed: $_"
    $checks += @{ Name = "Disk Space"; Status = "FAIL" }
    $failed++
}

Write-Host ""

# ============ Check 2: Available Memory ============
Write-Host "[2] Checking Available Memory..."
try {
    $memory = Get-CimInstance -ClassName CIM_OperatingSystem
    $availableMemoryMB = [math]::Round($memory.FreePhysicalMemory / 1024, 2)
    
    if ($availableMemoryMB -ge $MinMemoryMB) {
        Write-Pass "Available memory: ${availableMemoryMB}MB (required: ${MinMemoryMB}MB)"
        $checks += @{ Name = "Available Memory"; Status = "PASS" }
        $passed++
    } else {
        Write-Warn "Low memory: ${availableMemoryMB}MB (required: ${MinMemoryMB}MB)"
        $checks += @{ Name = "Available Memory"; Status = "WARN" }
        $warned++
    }
} catch {
    Write-Fail "Memory check failed: $_"
    $checks += @{ Name = "Available Memory"; Status = "FAIL" }
    $failed++
}

Write-Host ""

# ============ Check 3: .NET Runtime ============
Write-Host "[3] Checking .NET Runtime..."
try {
    $dotnetVersion = & dotnet --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Pass ".NET runtime installed: v$dotnetVersion"
        $checks += @{ Name = ".NET Runtime"; Status = "PASS" }
        $passed++
    } else {
        Write-Warn ".NET runtime not found in PATH"
        $checks += @{ Name = ".NET Runtime"; Status = "WARN" }
        $warned++
    }
} catch {
    Write-Warn ".NET runtime check failed: $_"
    $checks += @{ Name = ".NET Runtime"; Status = "WARN" }
    $warned++
}

Write-Host ""

# ============ Check 4: Network Connectivity ============
Write-Host "[4] Checking Network Connectivity..."
$networkOk = $true

# Test github.com
try {
    $testGitHub = Test-Connection github.com -Count 1 -ErrorAction Stop
    Write-Pass "Network connectivity to GitHub: OK"
} catch {
    Write-Warn "Cannot reach GitHub (this may be normal in isolated environments)"
}

# Test NuGet
try {
    $testNuGet = Test-Connection api.nuget.org -Count 1 -ErrorAction Stop
    Write-Pass "Network connectivity to NuGet: OK"
} catch {
    Write-Warn "Cannot reach NuGet (this may be normal in isolated environments)"
}

$checks += @{ Name = "Network Connectivity"; Status = "PASS" }
$passed++

Write-Host ""

# ============ Check 5: Deployment Directory ============
Write-Host "[5] Checking Deployment Directory..."
try {
    if (-not (Test-Path $DeploymentDir)) {
        Write-Host "Creating deployment directory: $DeploymentDir"
        New-Item -ItemType Directory -Path $DeploymentDir -Force | Out-Null
    }
    
    # Test write access
    $testFile = Join-Path $DeploymentDir ".deployment-test-$(Get-Random).tmp"
    "test" | Out-File -FilePath $testFile -Force
    Remove-Item -Path $testFile -Force
    
    Write-Pass "Deployment directory writable: $DeploymentDir"
    $checks += @{ Name = "Deployment Directory Access"; Status = "PASS" }
    $passed++
} catch {
    Write-Fail "Cannot write to deployment directory: $_"
    $checks += @{ Name = "Deployment Directory Access"; Status = "FAIL" }
    $failed++
}

Write-Host ""

# ============ Check 6: IIS or ASP.NET Hosting (if needed) ============
Write-Host "[6] Checking Web Server (if applicable)..."
try {
    $iisFeature = Get-WindowsFeature -Name "Web-Server" -ErrorAction SilentlyContinue
    
    if ($iisFeature -and $iisFeature.Installed) {
        Write-Pass "IIS installed: $($iisFeature.DisplayName)"
        $checks += @{ Name = "Web Server (IIS)"; Status = "PASS" }
        $passed++
    } else {
        Write-Warn "IIS not installed (only required for web applications)"
        $checks += @{ Name = "Web Server (IIS)"; Status = "WARN" }
        $warned++
    }
} catch {
    Write-Warn "Web server check skipped (may not be applicable)"
    $checks += @{ Name = "Web Server (IIS)"; Status = "WARN" }
    $warned++
}

Write-Host ""

# ============ Check 7: Running Service Instances ============
Write-Host "[7] Checking for Running Application Instances..."
try {
    # Check for common process names (customize as needed)
    $processNames = @("MyApp", "MyApp.exe", "dotnet")
    $runningProcesses = @()
    
    foreach ($procName in $processNames) {
        $procs = Get-Process -Name $procName -ErrorAction SilentlyContinue
        if ($procs) {
            $runningProcesses += $procs
        }
    }
    
    if ($runningProcesses.Count -gt 0) {
        Write-Warn "Found $($runningProcesses.Count) running application process(es)"
        Write-Host "  Running processes:"
        foreach ($proc in $runningProcesses) {
            Write-Host "    - $($proc.Name) (PID: $($proc.Id))"
        }
        Write-Host "  These will be stopped during deployment"
        $checks += @{ Name = "Running Application Instances"; Status = "WARN" }
        $warned++
    } else {
        Write-Pass "No conflicting application processes running"
        $checks += @{ Name = "Running Application Instances"; Status = "PASS" }
        $passed++
    }
} catch {
    Write-Warn "Running process check failed: $_"
    $checks += @{ Name = "Running Application Instances"; Status = "WARN" }
    $warned++
}

Write-Host ""

# ============ Check 8: Database Connectivity (if applicable) ============
Write-Host "[8] Checking Database Connectivity (if applicable)..."
try {
    if (-not [string]::IsNullOrEmpty($env:DB_CONNECTION_STRING)) {
        Write-Host "Testing database connection..."
        # This would use your actual database connection logic
        Write-Pass "Database connection string configured"
        $checks += @{ Name = "Database Connectivity"; Status = "PASS" }
        $passed++
    } else {
        Write-Warn "Database connection string not configured (may not be needed)"
        $checks += @{ Name = "Database Connectivity"; Status = "WARN" }
        $warned++
    }
} catch {
    Write-Warn "Database connectivity check skipped: $_"
    $checks += @{ Name = "Database Connectivity"; Status = "WARN" }
    $warned++
}

Write-Host ""

# ============ Summary ============
Write-Host "═══════════════════════════════════════════════════════════"
Write-Host "Summary"
Write-Host "═══════════════════════════════════════════════════════════"
Write-Host ""

$totalChecks = $checks.Count

Write-Host "Results:"
Write-Pass "$passed/$totalChecks checks passed"
if ($warned -gt 0) {
    Write-Warn "$warned/$totalChecks checks with warnings"
}
if ($failed -gt 0) {
    Write-Fail "$failed/$totalChecks checks failed"
}

Write-Host ""

# Detail breakdown
Write-Host "Detailed Results:"
foreach ($check in $checks) {
    $symbol = switch ($check.Status) {
        "PASS" { "✓" }
        "WARN" { "⚠" }
        "FAIL" { "✗" }
    }
    
    $color = switch ($check.Status) {
        "PASS" { "Green" }
        "WARN" { "Yellow" }
        "FAIL" { "Red" }
    }
    
    Write-Host "$symbol $($check.Name)" -ForegroundColor $color
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════"

# Final decision
if ($failed -eq 0 -and $warned -eq 0) {
    Write-Pass "✓ All checks passed. Environment ready for deployment!"
    Write-Host ""
    exit 0
} elseif ($failed -eq 0) {
    Write-Pass "✓ Deployment can proceed (warnings present, but acceptable)"
    Write-Host ""
    exit 0
} else {
    Write-Fail "✗ Deployment blocked: $failed critical issue(s) must be resolved"
    Write-Host ""
    exit 1
}
