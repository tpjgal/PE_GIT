# VC++ GitHub Actions - Quick Reference

## 🚀 Quick Commands

### Test Locally Before Pushing

```powershell
# Build locally first
& "$Env:ProgramFiles(x86)\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" MyProject.sln `
  /p:Configuration=Release /p:Platform=x64

# Run tests locally
My ProjectTests.exe

# Create package
[Compress-Archive](file:///docs/powershell/Compress-Archive.md) -Path "Release\" -DestinationPath "MyProject.zip"
```

### Create a Release Manually

```bash
# 1. Tag your code
git tag v1.0.0 -m "Release version 1.0.0"

# 2. Push tag to GitHub
git push origin v1.0.0

# 3. Go to GitHub Releases and create release from tag
# This triggers code signing and packaging

# Workflows will run automatically
```

### Download Artifacts

```powershell
# Using GitHub CLI
gh run download <run-id> -n build-output-Release-x64

# Or manually from GitHub Actions UI:
# 1. Actions tab
# 2. Select workflow run
# 3. Scroll to Artifacts
# 4. Click download
```

---

## 📋 Workflow Triggers

| Trigger | Workflow | Action |
|---------|----------|--------|
| Push to `main` | CI/CD | Build, test, package |
| Push to `develop` | CI/CD | Build, test |
| Pull Request | CI/CD | Build, test, coverage |
| Create Release | Code Signing | Sign binaries, create packages |
| Manual dispatch | CI/CD | Build on demand |
| Schedule (optional) | CI/CD | Nightly builds |

---

## 🔑 Required Secrets

For basic CI/CD (no code signing):
```
# None required!
Workflows run with default permissions
```

For code signing & releases:
```
SIGNING_CERTIFICATE_BASE64      # Base64-encoded PFX certificate
SIGNING_CERTIFICATE_PASSWORD    # PFX file password
```

For deployment:
```
DEPLOYMENT_SERVER_HOST          # e.g., prod-server.example.com
DEPLOYMENT_SERVER_USER          # Deployment account username
DEPLOYMENT_SERVER_PASSWORD      # Deployment account password
SLACK_WEBHOOK_URL              # (Optional) For notifications
```

---

## 📁 Workflow Files Overview

### vcpp-ci-cd-main.yml

**What it does:**
```
1. Analyze code (Cppcheck) → 5 min
2. Build (x86 & x64) → 10 min
3. Test → 5 min
4. Coverage → 8 min
5. Package → 3 min
6. Report → 1 min
```

**Artifacts generated:**
- Build outputs
- Test results  
- Coverage reports
- ZIP packages

**Example path:**
`.github/workflows/vcpp-ci-cd-main.yml`

### vcpp-code-signing-release.yml

**What it does:**
```
1. Build Release version (x64)
2. Sign executable & DLLs
3. Verify signatures
4. Create ZIP/MSI packages
5. Publish to GitHub Releases
```

**Triggers:**
- Release published on GitHub
- Manual workflow dispatch

**Requirements:**
- Code signing certificate in secrets

### vcpp-deployment.yml

**What it does:**
```
1. Validate package integrity
2. Pre-deployment checks
3. Deploy to staging
4. Health checks & smoke tests
5. Deploy to production (approval required)
```

**Environments:**
- Staging (automatic)
- Production (requires approval)

---

## 🔧 Configuration Quick Reference

### Update Solution File

```yaml
# Find in: vcpp-ci-cd-main.yml
env:
  SOLUTION_FILE: 'path/to/YourSolution.sln'
```

### Update Project File

```yaml
env:
  PROJECT_FILE: 'src/YourProject.vcxproj'
```

### Change Build Configurations

```yaml
strategy:
  matrix:
    configuration: [Debug, Release]      # Configurations to build
    platform: [x64, Win32]                # Platforms to build
```

### Disable Code Signing

```yaml
# In vcpp-code-signing-release.yml
# Comment out the job:
# sign-code:
#   ...
```

### Change Artifact Retention

```yaml
- uses: actions/upload-artifact@v3
  with:
    retention-days: 30  # Change this value
```

---

## 🧪 Testing Workflows

### Test Build Locally First

```powershell
# Test exact build command
$solution = "MyProject.sln"
$config = "Release"
$platform = "x64"

& "$Env:VS_PATH\MSBuild\Current\Bin\MSBuild.exe" $solution `
  /p:Configuration=$config `
  /p:Platform=$platform
```

### Run Tests Locally

```powershell
# Google Test format
# Your test binary should output like this:
.\MyProjectTests.exe --gtest_output="xml:results.xml"

# Check for PASSED
# If passed locally, it should pass in GitHub Actions
```

### Verify Package Contents

```powershell
# Extract and check
Expand-Archive -Path "MyProject-v1.0.0.zip" -DestinationPath ".\test_extract" -Force
dir .\test_extract -Recurse
```

---

## 🐛 Common Issues & Fixes

### "Workflow never triggers"

**Check:**
1. File is in `.github/workflows/` directory
2. File is named `*.yml` or `*.yaml`
3. `on:` trigger is configured
4. Branch name matches trigger (e.g., `main` vs `master`)

**Fix:**
```bash
# Verify file exists and format
ls -la .github/workflows/vcpp-*.yml

# Check YAML syntax
# Use GitHub web editor - it validates automatically
```

### "Build fails: MSBuild not found"

**Check:**
```powershell
# Verify MSBuild path
Test-Path "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
```

**Fix:**
```yaml
# Update path in workflow
MSBUILD_PATH: 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe'
```

### "Tests don't run"

**Check:**
```powershell
# Test binary exists
Get-ChildItem -Filter "*Tests.exe" -Recurse

# Can run manually
.\MyProjectTests.exe
```

**Fix:**
```yaml
# Update test path in workflow
$testBinary = "...\release\MyProjectTests.exe"
```

### "Code signing fails"

**Check:**
```powershell
# Certificate exists and is valid
Get-ChildItem Cert:\LocalMachine\My | Where {$_.Subject -like "*Code*"}
```

**Fix:**
1. Export certificate to base64
2. Update `SIGNING_CERTIFICATE_BASE64` secret
3. Verify password is correct

---

## 📊 Performance Tips

### Speed Up Builds

✅ Cache NuGet packages:
```yaml
- uses: NuGet/setup-nuget@v1

- name: Cache NuGet
  uses: actions/cache@v3
  with:
    path: ~/.nuget
    key: ${{ runner.os }}-nuget-${{ hashFiles('**/packages.config') }}
```

✅ Only test Release x64:
```yaml
strategy:
  matrix:
    configuration: [Release]  # Just Release
    platform: [x64]           # Just x64
```

✅ Reduce matrix:
```yaml
strategy:
  matrix:
    node: [20]  # Test on latest only
    include:
      - test-old: true  # Add specific old version if needed
```

### Monitor Build Time

```powershell
# GitHub Actions shows timing:
# 1. Go to workflow run
# 2. Each job shows execution time
# 3. Optimize slow jobs
```

---

## 🔐 Security Checklist

### Before First Release

- [ ] Code signing certificate obtained
- [ ] Certificate imported as base64 secret
- [ ] Code signing password stored securely
- [ ] Deployment credentials configured
- [ ] Staging environment ready
- [ ] Production environment ready
- [ ] Backup procedures documented

### Before Each Release

- [ ] All tests passing locally
- [ ] Code reviewed
- [ ] No hardcoded secrets in code
- [ ] Changelog updated
- [ ] Version number bumped
- [ ] Tag created for release

---

## 📞 Essential Links

| Resource | URL |
|----------|-----|
| Full Setup Guide | `VCPP-CI-CD-SETUP.md` |
| Quick Start | `VCPP-QUICK-START.md` |
| GitHub Actions Docs | https://docs.github.com/actions |
| MSBuild Reference | https://docs.microsoft.com/msbuild |
| Code Signing | https://docs.microsoft.com/en-us/windows/win32/seccrypto/signtool |

---

## 🎯 Workflow Decision Tree

```
Start
├─ Just CI (build & test)?
│  └─ Use: vcpp-ci-cd-main.yml ✓
├─ Need releases & code signing?
│  └─ Use: vcpp-ci-cd-main.yml + vcpp-code-signing-release.yml ✓
└─ Full CI/CD with deployment?
   └─ Use: All 3 workflows ✓
      └─ Configure: Secrets + environments ✓
```

---

## 📋 Pre-Deployment Checklist

Before deploying to production:

- [ ] Staging deployment successful
- [ ] All smoke tests passed
- [ ] Performance acceptable
- [ ] Logs reviewed for errors
- [ ] Database backups completed
- [ ] Rollback plan ready
- [ ] Team notified
- [ ] Approval granted

---

## 💡 Pro Tips

1. **Start simple** - Just CI first, add features later
2. **Test locally** - Always build/test locally before pushing
3. **Use staging** - Never deploy directly to production
4. **Monitor times** - Each workflow should take ~30 min max
5. **Keep secrets safe** - Never commit certificates
6. **Document changes** - Update release notes
7. **Backup always** - Before deployment to production
8. **Review logs** - Check workflow logs for warnings

---

**Last Updated:** March 2026
**Version:** 1.0
