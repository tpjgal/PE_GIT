# YAML Environment Setup Script (PowerShell)
# This script sets up the YAML working environment

param(
    [switch]$InstallDeps = $true
)

function Write-Header {
    param([string]$Title)
    Write-Host "`n$('='*70)" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "$('='*70)`n" -ForegroundColor Cyan
}

function Test-PythonInstalled {
    Write-Host "Checking for Python..." -ForegroundColor Yellow
    
    try {
        $version = python --version 2>&1
        Write-Host "✅ Python is installed: $version" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Python is not installed or not in PATH" -ForegroundColor Red
        return $false
    }
}

function Install-PyYAML {
    if (-not $InstallDeps) {
        Write-Host "Skipping package installation." -ForegroundColor Yellow
        return
    }
    
    Write-Header "Installing PyYAML Package"
    
    try {
        Write-Host "Installing PyYAML..." -ForegroundColor Yellow
        python -m pip install pyyaml -q
        Write-Host "✅ PyYAML installed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️  PyYAML installation may have had issues" -ForegroundColor Yellow
        Write-Host "   Try manually: pip install pyyaml" -ForegroundColor Yellow
    }
}

function Get-YAMLFiles {
    Write-Header "YAML Workspace Files"
    
    $yamlDir = "c:\Users\ponni\source\repos\PE_GIT\YAML"
    
    if (-not (Test-Path $yamlDir)) {
        Write-Host "❌ Directory not found: $yamlDir" -ForegroundColor Red
        return
    }
    
    Write-Host "📂 Directory: $yamlDir`n" -ForegroundColor Cyan
    
    # YAML files
    $yamlFiles = Get-ChildItem -Path $yamlDir -Filter "*.yaml" -File
    if ($yamlFiles) {
        Write-Host "📋 YAML Files:" -ForegroundColor Yellow
        foreach ($file in $yamlFiles) {
            $size = $file.Length
            Write-Host "   ✅ $($file.Name) ($size bytes)" -ForegroundColor Green
        }
    }
    
    # Documentation files
    $docFiles = Get-ChildItem -Path $yamlDir -Filter "*.md" -File
    if ($docFiles) {
        Write-Host "`n📚 Documentation:" -ForegroundColor Yellow
        foreach ($file in $docFiles) {
            Write-Host "   📄 $($file.Name)" -ForegroundColor Cyan
        }
    }
    
    # Python scripts
    $pyFiles = Get-ChildItem -Path $yamlDir -Filter "*.py" -File
    if ($pyFiles) {
        Write-Host "`n🐍 Python Scripts:" -ForegroundColor Yellow
        foreach ($file in $pyFiles) {
            Write-Host "   🔧 $($file.Name)" -ForegroundColor Magenta
        }
    }
}

function Show-Commands {
    Write-Header "Available Commands"
    
    $commands = @(
        @{ Name = "Validate YAML files"; Cmd = "python validate_yaml.py"; Icon = "✓" },
        @{ Name = "Parse and visualize YAML"; Cmd = "python parse_yaml.py"; Icon = "📊" },
        @{ Name = "Setup environment"; Cmd = "python setup_environment.py"; Icon = "⚙️" }
    )
    
    foreach ($cmd in $commands) {
        Write-Host "$($cmd.Icon) $($cmd.Name)" -ForegroundColor Yellow
        Write-Host "   Run: $($cmd.Cmd)" -ForegroundColor Cyan
    }
}

# Main execution
Clear-Host
Write-Host "`n" + ("╔" + "="*68 + "╗") -ForegroundColor Cyan
Write-Host ("║" + (" "*18 + "YAML ENVIRONMENT SETUP" + " "*27) + "║") -ForegroundColor Cyan
Write-Host ("╚" + "="*68 + "╝") -ForegroundColor Cyan

Write-Header "1️⃣  System Information"
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Cyan
Write-Host "OS: $([System.Environment]::OSVersion.VersionString)" -ForegroundColor Cyan

if (Test-PythonInstalled) {
    python --version
    
    Install-PyYAML
    Get-YAMLFiles
    Show-Commands
    
    Write-Host "`n$('='*70)" -ForegroundColor Cyan
    Write-Host "✅ Setup Complete! Ready to work with YAML." -ForegroundColor Green
    Write-Host "$('='*70)`n" -ForegroundColor Cyan
}
else {
    Write-Host "`n❌ Setup cannot continue without Python." -ForegroundColor Red
    Write-Host "   Install Python from: https://www.python.org" -ForegroundColor Yellow
}
