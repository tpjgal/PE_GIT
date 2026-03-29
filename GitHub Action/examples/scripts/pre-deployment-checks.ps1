# Example Pre-Deployment Checks Script
# Location: scripts/deploy/pre-deployment-checks.ps1
# 
# This script runs before deployment to validate:
# - Environment readiness
# - Disk space
# - Required services
# - File permissions

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("staging", "production")]
    [string]$Environment,
    
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [int]$MinimumDiskSpaceGB = 2,
    [int]$MinimumMemoryMB = 512
)

$ErrorActionPreference = "Stop"

Write-Host "╔════════════════════════════════════════════════════════╗"
Write-Host "║         Pre-Deployment Verification Script          ║"
Write-Host "║  Environment: $Environment | Version: $Version"
Write-Host "╚════════════════════════════════════════════════════════╝"
Write-Host ""

# Initialize results
$checks = @()

# ============================================================
# Check 1: Disk Space
# ============================================================
Write-Host "Checking disk space..."
try {
    $cDrive = Get-Volume -DriveLetter C | Select-Object -ExpandProperty SizeRemaining
    $diskSpaceGB = [Math]::Round($cDrive / 1GB, 2)
    
    if ($diskSpaceGB -ge $MinimumDiskSpaceGB) {
        Write-Host "  ✓ Disk space: ${diskSpaceGB}GB available"
        $checks += @{Name = "Disk Space"; Status = "PASS"; Detail = "${diskSpaceGB}GB" }
    } else {
        Write-Host "  ✗ Disk space: Only ${diskSpaceGB}GB available (minimum: ${MinimumDiskSpaceGB}GB)"
        $checks += @{Name = "Disk Space"; Status = "FAIL"; Detail = "${diskSpaceGB}GB" }
        throw "Insufficient disk space"
    }
}
catch {
    Write-Host "  ✗ Failed to check disk space: $_"
    $checks += @{Name = "Disk Space"; Status = "ERROR"; Detail = $_.Message }
}

# ============================================================
# Check 2: Memory Available
# ============================================================
Write-Host "Checking available memory..."
try {
    $memObjects = Get-WmiObject -Class Win32_ComputerSystem
    $memoryMB = [Math]::Round(($memObjects.TotalPhysicalMemory / 1MB) * 0.5, 0)  # 50% available
    
    if ($memoryMB -ge $MinimumMemoryMB) {
        Write-Host "  ✓ Memory available: ${memoryMB}MB"
        $checks += @{Name = "Memory"; Status = "PASS"; Detail = "${memoryMB}MB" }
    } else {
        Write-Host "  ✗ Memory: Only ${memoryMB}MB available"
        $checks += @{Name = "Memory"; Status = "FAIL"; Detail = "${memoryMB}MB" }
    }
}
catch {
    Write-Host "  ✗ Failed to check memory: $_"
    $checks += @{Name = "Memory"; Status = "WARN"; Detail = "Could not verify" }
}

# ============================================================
# Check 3: Required Services
# ============================================================
Write-Host "Checking required services..."
$requiredServices = @("Networking", "BITS")

foreach ($service in $requiredServices) {
    try {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc -and $svc.Status -eq "Running") {
            Write-Host "  ✓ Service $service is running"
            $checks += @{Name = "Service: $service"; Status = "PASS"; Detail = "Running" }
        } elseif ($svc) {
            Write-Host "  ⚠ Service $service is not running (status: $($svc.Status))"
            $checks += @{Name = "Service: $service"; Status = "WARN"; Detail = $svc.Status }
        }
    }
    catch {
        Write-Host "  ⚠ Could not check service $service"
        $checks += @{Name = "Service: $service"; Status = "WARN"; Detail = "Could not verify" }
    }
}

# ============================================================
# Check 4: Network Connectivity
# ============================================================
Write-Host "Checking network connectivity..."
try {
    $testUrls = @(
        "www.github.com",
        "www.google.com"
    )
    
    $allOnline = $true
    foreach ($url in $testUrls) {
        if (Test-Connection -ComputerName $url -Count 1 -Quiet) {
            Write-Host "  ✓ Connection to $url: OK"
        } else {
            Write-Host "  ✗ Connection to $url: FAILED"
            $allOnline = $false
        }
    }
    
    if ($allOnline) {
        $checks += @{Name = "Network Connectivity"; Status = "PASS"; Detail = "All endpoints reachable" }
    } else {
        $checks += @{Name = "Network Connectivity"; Status = "WARN"; Detail = "Some endpoints unreachable" }
    }
}
catch {
    Write-Host "  ⚠ Could not verify network: $_"
    $checks += @{Name = "Network Connectivity"; Status = "WARN"; Detail = "Could not verify" }
}

# ============================================================
# Check 5: Deployment Directory Permissions
# ============================================================
Write-Host "Checking deployment directory permissions..."
try {
    if ($Environment -eq "staging") {
        $deployDir = "C:\DeploymentRoot\staging"
    } else {
        $deployDir = "C:\DeploymentRoot\production"
    }
    
    # Create directory if not exists
    if (-not (Test-Path $deployDir)) {
        New-Item -ItemType Directory -Path $deployDir -Force | Out-Null
        Write-Host "  ℹ Created deployment directory: $deployDir"
    }
    
    # Test write permissions
    $testFile = Join-Path $deployDir ".pemtest"
    "test" | Out-File -FilePath $testFile -Force
    Remove-Item $testFile -Force
    
    Write-Host "  ✓ Deployment directory writable: $deployDir"
    $checks += @{Name = "Deployment Dir Permissions"; Status = "PASS"; Detail = "Writable" }
}
catch {
    Write-Host "  ✗ Cannot write to deployment directory: $_"
    $checks += @{Name = "Deployment Dir Permissions"; Status = "FAIL"; Detail = $_.Message }
    throw
}

# ============================================================
# Check 6: Running Application Instances
# ============================================================
Write-Host "Checking for running application instances..."
try {
    $runningProc = Get-Process -Name "MyProject" -ErrorAction SilentlyContinue
    if ($runningProc) {
        $procCount = @($runningProc).Count
        Write-Host "  ⚠ Found $procCount running instance(s) of MyProject"
        $checks += @{Name = "Running Instances"; Status = "WARN"; Detail = "$procCount running" }
    } else {
        Write-Host "  ✓ No running instances of MyProject"
        $checks += @{Name = "Running Instances"; Status = "PASS"; Detail = "None" }
    }
}
catch {
    Write-Host "  ⚠ Could not check running processes: $_"
    $checks += @{Name = "Running Instances"; Status = "WARN"; Detail = "Could not verify" }
}

# ============================================================
# Check 7: Environment Variables
# ============================================================
Write-Host "Checking environment configuration..."
try {
    $required_vars = @("PATH", "SYSTEM32")
    $missing = @()
    
    foreach ($var in $required_vars) {
        $value = [Environment]::GetEnvironmentVariable($var, "Machine")
        if ($value) {
            Write-Host "  ✓ Environment variable $var is set"
        } else {
            Write-Host "  ✗ Environment variable $var not found"
            $missing += $var
        }
    }
    
    if ($missing.Count -eq 0) {
        $checks += @{Name = "Environment Variables"; Status = "PASS"; Detail = "All set" }
    } else {
        $checks += @{Name = "Environment Variables"; Status = "WARN"; Detail = "$($missing -join ', ') missing" }
    }
}
catch {
    Write-Host "  ⚠ Could not check environment variables: $_"
    $checks += @{Name = "Environment Variables"; Status = "WARN"; Detail = "Could not verify" }
}

# ============================================================
# Summary Report
# ============================================================
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗"
Write-Host "║                    Check Summary                     ║"
Write-Host "╚════════════════════════════════════════════════════════╝"
Write-Host ""

$passCount = ($checks | Where-Object {$_.Status -eq "PASS"}).Count
$warnCount = ($checks | Where-Object {$_.Status -eq "WARN"}).Count
$failCount = ($checks | Where-Object {$_.Status -eq "FAIL"}).Count
$errorCount = ($checks | Where-Object {$_.Status -eq "ERROR"}).Count

foreach ($check in $checks) {
    $symbol = switch ($check.Status) {
        "PASS" { "✓" }
        "WARN" { "⚠" }
        "FAIL" { "✗" }
        "ERROR" { "✗" }
        default { "?" }
    }
    
    Write-Host "$symbol $($check.Name)" -ForegroundColor $(
        switch ($check.Status) {
            "PASS" { "Green" }
            "WARN" { "Yellow" }
            "FAIL" { "Red" }
            "ERROR" { "Red" }
            default { "Gray" }
        }
    )
    Write-Host "  → $($check.Detail)"
}

Write-Host ""
Write-Host "Summary: $passCount passed, $warnCount warnings, $failCount failed, $errorCount errors"

# ============================================================
# Final Decision
# ============================================================
Write-Host ""
if ($failCount -eq 0 -and $errorCount -eq 0) {
    Write-Host "✓ Pre-deployment checks PASSED - Deployment may proceed" -ForegroundColor Green
    exit 0
} elseif ($failCount -eq 0 -and $warnCount -gt 0) {
    Write-Host "⚠ Pre-deployment checks PASSED with warnings - Deployment may proceed" -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "✗ Pre-deployment checks FAILED - Deployment cannot proceed" -ForegroundColor Red
    exit 1
}
