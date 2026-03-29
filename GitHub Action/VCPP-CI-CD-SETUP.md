# VC++ GitHub Actions CI/CD Complete Guide

## Overview

This guide provides complete setup and configuration instructions for GitHub Actions CI/CD for Visual C++ projects. It covers:

- **CI/CD Pipeline** - Building, testing, and packaging
- **Code Signing** - Securing your releases with digital signatures
- **Deployment** - Staging and production deployment
- **Unit Testing** - Automated test execution
- **Code Coverage** - Coverage reporting
- **Packaging** - ZIP and MSI installer creation

---

## 📋 Prerequisites

### Local Development Environment

1. **Visual Studio 2022** (Enterprise, Professional, or Community)
   - C++ development tools
   - MSBuild included

2. **Dependencies**
   ```powershell
   # Install via Chocolatey
   choco install vcredist2022
   choco install googletest
   choco install wixtoolset
   choco install cmake
   ```

3. **Git**
   ```powershell
   choco install git
   ```

### GitHub Repository Setup

1. Create a new repository or use existing one
2. Clone to your local machine
3. Create `.github/workflows/` directory
4. Copy workflow YAML files from `examples/`

---

## 🔧 Configuration Steps

### Step 1: Configure Paths in Workflows

Edit the environment variables in `vcpp-ci-cd-main.yml`:

```yaml
env:
  VS_PATH: 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise'
  SOLUTION_FILE: 'MyProject.sln'              # Your solution file
  PROJECT_FILE: 'src/MyProject.vcxproj'       # Your project file
```

**Find your Visual Studio path:**
```powershell
Get-ChildItem "C:\Program Files\Microsoft Visual Studio\2022\"
```

### Step 2: Project Structure

Organize your project like this:

```
MyProject/
├── .github/
│   └── workflows/
│       ├── vcpp-ci-cd-main.yml
│       ├── vcpp-code-signing-release.yml
│       └── vcpp-deployment.yml
├── src/
│   ├── MyProject.vcxproj
│   ├── MyProject.cpp
│   └── MyProject.h
├── tests/
│   ├── MyProjectTests.vcxproj
│   └── MyProjectTests.cpp
├── setup/
│   └── MyProject.wxs              # WiX setup file
├── scripts/
│   └── deploy/
│       ├── pre-deployment-checks.ps1
│       └── post-deployment.ps1
├── MyProject.sln
├── CMakeLists.txt
└── README.md
```

### Step 3: Solution File Configuration

Ensure your Visual Studio solution builds correctly:

```powershell
# Test local build
& "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" MyProject.sln `
  /p:Configuration=Release `
  /p:Platform=x64
```

### Step 4: Unit Tests Setup

Install Google Test:

```powershell
choco install googletest
```

Create test project in `tests/MyProjectTests.vcxproj`:

```cpp
// MyProjectTests.cpp
#include <gtest/gtest.h>
#include "../src/MyProject.h"

TEST(MyProjectTest, TestBasicFunctionality) {
    EXPECT_EQ(1 + 1, 2);
}

int main(int argc, char** argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
```

### Step 5: Code Signing Setup (Optional but Recommended)

For production releases, you need:

1. **Acquire a Code Signing Certificate**
   - Purchase from trusted CA (DigiCert, Comodo, etc.)
   - Or create self-signed for testing:
   ```powershell
   $cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My `
     -Subject "CN=MyCompany Code Signing" -Type CodeSigningCert -KeyExportPolicy Exportable
   ```

2. **Export Certificate as Base64**
   ```powershell
   # Export PFX
   Export-PfxCertificate -Cert $cert -FilePath "codesigning.pfx" -Password (ConvertTo-SecureString "password" -AsPlainText -Force)
   
   # Convert to Base64
   $pfxBytes = [System.IO.File]::ReadAllBytes("codesigning.pfx")
   $base64 = [System.Convert]::ToBase64String($pfxBytes)
   Set-Clipboard -Value $base64
   ```

3. **Add Secrets to GitHub**
   - Go to Settings → Secrets → Actions
   - Add `SIGNING_CERTIFICATE_BASE64` - paste the base64 string
   - Add `SIGNING_CERTIFICATE_PASSWORD` - the PFX password

### Step 6: Create GitHub Secrets

Go to your repository Settings → Secrets and Actions → Secrets:

**Required Secrets:**

```
SIGNING_CERTIFICATE_BASE64      # Code signing certificate (base64)
SIGNING_CERTIFICATE_PASSWORD    # Certificate password
DEPLOYMENT_SERVER_HOST          # Deployment target server
DEPLOYMENT_SERVER_USER          # Deployment user
DEPLOYMENT_SERVER_PASSWORD      # Deployment password
```

**Optional Secrets:**

```
SLACK_WEBHOOK_URL               # For Slack notifications
TEAMS_WEBHOOK_URL               # For Teams notifications
NUGET_API_KEY                   # For NuGet packages
```

### Step 7: Create Deployment Scripts

Create `scripts/deploy/pre-deployment-checks.ps1`:

```powershell
param(
    [string]$Environment,
    [string]$Version
)

Write-Host "Pre-deployment checks for $Environment v$Version"

# Check disk space
$diskSpace = (Get-Volume -DriveLetter C | Select-Object -ExpandProperty SizeRemaining) / 1GB
if ($diskSpace -lt 1) {
    throw "Insufficient disk space: ${diskSpace}GB available"
}

# Check running processes
$running = Get-Process -Name "MyProject" -ErrorAction SilentlyContinue
if ($running) {
    Write-Host "Warning: MyProject is running on this system"
}

Write-Host "✓ Pre-deployment checks passed"
```

---

## 🚀 Running Workflows

### Trigger Manually

1. Go to GitHub repository
2. Click "Actions" tab
3. Select workflow: "VC++ CI/CD Pipeline"
4. Click "Run workflow"
5. Select branch and options
6. Click "Run workflow"

### Trigger on Commit

Workflows run automatically on:

- **Push to branches**: `main`, `develop`, `release/*`
- **Pull requests** to `main` or `develop`
- **Releases** in GitHub
- **Schedule**: (configure in workflow)

### Trigger on Release

1. Go to Releases
2. Click "Create a new release"
3. Fill in tag version (e.g., `v1.0.0`)
4. Add release notes
5. Click "Publish release"
6. Code signing & deployment workflows triggered automatically

---

## 📊 Workflow Details

### CI/CD Pipeline Stages

```
┌─────────────────────────────────────┐
│ 1. CODE ANALYSIS                    │ (5 min)
│    - Static analysis (Cppcheck)     │
│    - Linting                        │
├─────────────────────────────────────┤
│ 2. BUILD (Parallel)                 │ (10 min)
│    - Debug x86, Release x86         │
│    - Debug x64, Release x64         │
├─────────────────────────────────────┤
│ 3. UNIT TESTS (Parallel)            │ (5 min)
│    - Tests on x86                   │
│    - Tests on x64                   │
├─────────────────────────────────────┤
│ 4. CODE COVERAGE                    │ (8 min)
│    - Coverage analysis              │
│    - HTML report generation         │
├─────────────────────────────────────┤
│ 5. PACKAGE                          │ (3 min)
│    - Create ZIP                     │
│    - Create MSI installer           │
├─────────────────────────────────────┤
│ 6. SUMMARY & REPORTING              │ (1 min)
│    - Build report                   │
│    - Artifact links                 │
└─────────────────────────────────────┘
Total: ~32 minutes
```

### Code Signing Pipeline

```
1. Build Release (x64)
2. Code Sign (EXE + DLL)
3. Verify Signatures
4. Create Packages
5. Generate Release Notes
6. Upload to GitHub Releases
```

### Deployment Pipeline

```
1. Prepare Deployment Package
   - Download artifacts
   - Validate checksums
   
2. Validate Environment
   - Check prerequisites
   - Test credentials
   - Health check
   
3. Deploy to Staging
   - Backup current version
   - Deploy new version
   - Health check
   - Smoke tests
   
4. Deploy to Production (requires approval)
   - Manual approval
   - Production deployment
   - Verification
```

---

## 📝 Customization Guide

### Change Build Configuration

Edit `vcpp-ci-cd-main.yml`:

```yaml
strategy:
  matrix:
    configuration: [Debug, Release]    # Add/remove configs
    platform: [x64, Win32]             # Add/remove platforms
```

### Change Solution File Path

```yaml
env:
  SOLUTION_FILE: 'path/to/YourSolution.sln'
```

### Add Custom Build Steps

```yaml
- name: Custom build step
  run: |
    # Your custom PowerShell commands
    Write-Host "Custom build step"
```

### Change Artifact Retention

```yaml
- uses: actions/upload-artifact@v3
  with:
    name: my-artifacts
    path: output/
    retention-days: 90              # Change this
```

### Add Slack Notifications

```yaml
- name: Notify Slack
  if: failure()
  uses: slackapi/slack-github-action@v1.24.0
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK_URL }}
    payload: |
      {
        "text": "Build failed: ${{ github.repository }}"
      }
```

---

## 🔍 Troubleshooting

### Build Fails: "MSBuild not found"

**Issue:** Workflow can't find MSBuild

**Solution:**
```powershell
# Verify MSBuild path
Get-Item "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\*"

# Update path in workflow
MSBUILD_PATH: 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe'
```

### Tests Fail: "Test binary not found"

**Issue:** Unit test executable not generated

**Solution:**
1. Ensure tests project builds locally:
   ```powershell
   & "MSBuild.exe" tests/MyProjectTests.vcxproj
   ```
2. Verify test project references in solution
3. Check test output path matches workflow

### Code Signing Fails: "Certificate not found"

**Issue:** Code signing certificate issues

**Solution:**
```powershell
# Verify certificate is valid
Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*Code Signing*"}

# Re-export certificate to Base64
$pfxBytes = [System.IO.File]::ReadAllBytes("codesigning.pfx")
$base64 = [System.Convert]::ToBase64String($pfxBytes)
[System.IO.File]::WriteAllText("cert.b64", $base64)
```

### Deployment Fails: "Target server unreachable"

**Issue:** Can't connect to deployment target

**Solution:**
1. Verify `DEPLOYMENT_SERVER_HOST` secret is correct
2. Check firewall rules
3. Verify VPN connection if needed
4. Test locally:
   ```powershell
   Test-Connection -ComputerName ${{ secrets.DEPLOYMENT_SERVER_HOST }}
   ```

---

## 📋 Artifacts Generated

### Build Artifacts

- `build-output-Release-x64/` - Release binaries
- `build-output-Debug-x86/` - Debug binaries

### Test Artifacts

- `test-results-x64/` - Test results XML
- `coverage-report/` - HTML coverage report

### Release Artifacts

- `MyProject-v1.0.0-win64.zip` - Portable package
- `MyProject-v1.0.0.msi` - Windows installer
- `RELEASE_NOTES.md` - Release documentation
- `CHECKSUMS.txt` - File integrity checksums

---

## 🔐 Security Best Practices

### Secrets Management

✅ **Do:**
- Store secrets in GitHub repository settings
- Use unique secrets per environment
- Rotate secrets regularly
- Use strong passwords for certificates

❌ **Don't:**
- Hardcode secrets in workflows
- Commit certificate files
- Share secrets via email
- Use same secret for all environments

### Code Signing

✅ **Do:**
- Use EV certificates for production
- Timestamp signatures
- Verify signatures before deployment
- Keep private keys secure

❌ **Don't:**
- Use self-signed certificates in production
- Store certificates in repositories
- Share private key passwords

### Deployment

✅ **Do:**
- Require approval for production deployments
- Use separate staging environment
- Backup before deployment
- Test in staging first

❌ **Don't:**
- Deploy directly to production
- Skip health checks
- Ignore backup errors

---

## 📞 Reference Links

### Official Documentation
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Microsoft Visual Studio Build Tools](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild)
- [Windows Code Signing](https://docs.microsoft.com/en-us/windows/win32/seccrypto/using-signtool-to-sign-a-file)

### Tools
- [Google Test Documentation](https://github.com/google/googletest)
- [Cppcheck Static Analysis](http://cppcheck.sourceforge.net/)
- [OpenCppCoverage](https://github.com/OpenCppCoverage/OpenCppCoverage)
- [WiX Toolset](https://wixtoolset.org/)

### External Resources
- [Microsoft Docs - Building C++ Projects](https://docs.microsoft.com/en-us/cpp/build/)
- [Code Signing Best Practices](https://www.ssl.com/article/code-signing-the-definitive-guide/)

---

## 📞 Common Errors & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `MSBuild not found` | Visual Studio not installed | Install VS2022 Enterprise |
| `Test binary not found` | Tests don't build | Check test project in solution |
| `Certificate invalid` | Expired or wrong cert | Export new base64 certificate |
| `Permission denied` | Insufficient file permissions | Run with admin privileges |
| `Out of disk space` | GitHub runner disk full | Clear artifacts or reduce matrix |
| `Deploy failed` | Network unreachable | Check firewall and VPN |

---

## 🎓 Next Steps

1. **Customize for your project**
   - Update solution/project file paths
   - Configure build configurations
   - Set up code signing

2. **Add team collaborators**
   - GitHub repository settings
   - Add to organization if needed
   - Set branch protection rules

3. **Set up notifications**
   - Slack integration
   - Email notifications
   - GitHub status checks

4. **Monitor and optimize**
   - Review build times
   - Configure matrix efficiently
   - Use caching strategically

---

## Support & Contributions

For issues or improvements:
1. Check GitHub Actions documentation
2. Review workflow logs in Actions tab
3. Enable debug logging with `ACTIONS_STEP_DEBUG`
4. Contact your CI/CD administrator

---

**Last Updated:** March 2026
**Version:** 1.0
