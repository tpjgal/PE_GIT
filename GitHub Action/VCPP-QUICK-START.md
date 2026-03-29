# VC++ GitHub Actions - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Copy Workflow Files (1 min)

```powershell
# Navigate to your repository
cd your-vcpp-project

# Create workflows directory
mkdir -p .github/workflows

# Copy workflow files from examples
Copy-Item "..\examples\vcpp-*.yml" -Destination ".github/workflows\" -Force
```

### Step 2: Update Configuration (2 min)

Edit `.github/workflows/vcpp-ci-cd-main.yml`:

```yaml
env:
  SOLUTION_FILE: 'MyProject.sln'           # ← Update this
  PROJECT_FILE: 'src/MyProject.vcxproj'    # ← Update this
```

### Step 3: Add Secrets (if using code signing) (1 min)

Go to your GitHub repository:
1. Settings → Secrets and variables → Actions
2. Add these secrets:
   - `SIGNING_CERTIFICATE_BASE64` - Your code signing cert (base64)
   - `SIGNING_CERTIFICATE_PASSWORD` - Certificate password

### Step 4: Push & Test (1 min)

```powershell
git add .github/workflows/
git commit -m "Add GitHub Actions CI/CD for VC++"
git push
```

Monitor in GitHub: **Actions** tab → Watch workflow run

✅ **Done!** Your CI/CD pipeline is running!

---

## 📋 What Each Workflow Does

### 1. vcpp-ci-cd-main.yml
**Main CI/CD Pipeline**
- Runs on every commit to `main`, `develop`, or PR
- ✓ Code analysis
- ✓ Builds (Debug & Release, x86 & x64)
- ✓ Unit tests
- ✓ Code coverage
- ✓ Packaging

**Status:** Runs automatically

### 2. vcpp-code-signing-release.yml
**Release & Code Signing**
- Runs when you create a GitHub Release
- ✓ Build release version
- ✓ Sign executable and DLL files
- ✓ Create packages (ZIP, MSI)
- ✓ Publish to GitHub Releases

**Trigger:** Create a Release in GitHub

### 3. vcpp-deployment.yml
**Production Deployment**
- Validates, stages, and deploys application
- ✓ Validates packages
- ✓ Pre-deployment checks
- ✓ Deploy to staging
- ✓ Deploy to production (with approval)

**Status:** Automated with approval gates

---

## 🎯 Common Workflows

### Workflow A: Simple CI (Testing & Building)

**Use these:**
- ✓ `vcpp-ci-cd-main.yml` - Main CI pipeline
- ✓ Keep code signing workflow disabled

**Trigger:** Every push to `develop` or `main`

```yaml
# In vcpp-ci-cd-main.yml
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
```

### Workflow B: CI + Release Signing

**Use these:**
- ✓ `vcpp-ci-cd-main.yml` - Main CI
- ✓ `vcpp-code-signing-release.yml` - Code signing

**Setup:**
1. Add code signing certificate to secrets
2. Tag a release: `v1.0.0`
3. Workflows run automatically

```bash
git tag v1.0.0
git push origin v1.0.0
```

### Workflow C: Full CI/CD with Deployment

**Use all three:**
- ✓ `vcpp-ci-cd-main.yml` - Main CI
- ✓ `vcpp-code-signing-release.yml` - Code signing
- ✓ `vcpp-deployment.yml` - Deployment

**Setup:**
1. Configure all three workflows
2. Add deployment secrets
3. Create release
4. Approve production deployment when prompted

---

## 📂 Required Project Structure

```
your-project/
├── .github/workflows/
│   ├── vcpp-ci-cd-main.yml
│   ├── vcpp-code-signing-release.yml
│   └── vcpp-deployment.yml
│
├── src/
│   ├── MyProject.vcxproj
│   ├── MyProject.cpp
│   └── MyProject.h
│
├── tests/
│   ├── MyProjectTests.vcxproj
│   └── MyProjectTests.cpp
│
├── setup/                       # For MSI creation
│   └── MyProject.wxs
│
├── MyProject.sln
├── README.md
└── LICENSE
```

---

## 🔧 Essential Configurations

### 1. Update Solution File Name

Find your `.sln` file:
```powershell
Get-ChildItem -Filter "*.sln" -Recurse
```

Update in `vcpp-ci-cd-main.yml`:
```yaml
env:
  SOLUTION_FILE: 'YourSolution.sln'
```

### 2. Configure Unit Tests

Ensure tests project exists in solution:
```powershell
# Should find your tests project
Get-ChildItem -Filter "*Tests.vcxproj" -Recurse
```

Update in `vcpp-ci-cd-main.yml`:
```yaml
$testBinary = "...\MyProjectTests.exe"  # Update this path
```

### 3. Set Up Code Signing (Optional)

Create a certificate:
```powershell
# Self-signed (testing only)
$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My `
  -Subject "CN=MyCompany" -Type CodeSigningCert -KeyExportPolicy Exportable

# Export to Base64
$pfxBytes = [IO.File]::ReadAllBytes("cert.pfx")
$base64 = [Convert]::ToBase64String($pfxBytes)
[IO.File]::WriteAllText("cert.b64", $base64)
```

Add secrets to GitHub repository

### 4. Configure Deployment (Optional)

Add deployment servers to secrets:
- `DEPLOYMENT_SERVER_HOST`
- `DEPLOYMENT_SERVER_USER`
- `DEPLOYMENT_SERVER_PASSWORD`

---

## ✅ Verification Checklist

- [ ] Solution file exists and builds locally
- [ ] Unit tests project exists and runs
- [ ] `.github/workflows/` directory created
- [ ] All 3 YAML files copied to `.github/workflows/`
- [ ] Updated `SOLUTION_FILE` path in workflows
- [ ] Added secrets for code signing (if using)
- [ ] Pushed code to GitHub
- [ ] Workflows visible in Actions tab

---

## 📊 Monitoring Builds

### View Build Status

1. Go to your GitHub repository
2. Click **Actions** tab
3. Select workflow run
4. View:
   - Build logs
   - Artifact downloads
   - Test results
   - Coverage reports

### Interpret Build Status

- ✅ **Green** - All checks passed
- ⚠️ **Yellow** - Running or waiting for approval
- ❌ **Red** - Build/tests failed
- ⏸️ **Grey** - Cancelled or skipped

### Download Artifacts

```powershell
# From Actions tab:
# 1. Go to completed workflow
# 2. Scroll to Artifacts section
# 3. Click to download:
#    - build-output-*
#    - test-results-*
#    - coverage-report
#    - packages
#    - signed-release
```

---

## 🐛 Troubleshooting Quick Fixes

### "Workflow shows as failed"

1. Click workflow → View logs
2. Search for `ERROR`
3. Common fixes:
   ```
   - MSBuild not found?    → Check Visual Studio path
   - Solution not found?   → Update SOLUTION_FILE path
   - Tests fail?           → Run tests locally first
   - Permission denied?    → Check GitHub secrets
   ```

### "Build output is empty"

```powershell
# Run locally to test
& "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" MyProject.sln `
  /p:Configuration=Release /p:Platform=x64
```

### "Tests not running"

```powershell
# Verify test executable path
Get-ChildItem -Filter "*Tests.exe" -Recurse -Path "your-build-dir"

# Update path in workflow
```

### "Code signing fails"

```powershell
# Verify certificate
Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*Signing*"}

# Re-create base64 secret
```

---

## 📚 Next Steps

1. **Run first build**
   - Make a test commit
   - Watch Actions tab
   - Download artifacts

2. **Configure tests**
   - Add unit tests
   - Enable code coverage
   - Review test reports

3. **Set up releases**
   - Create first tag: `v1.0.0`
   - Code signing runs automatically
   - Download signed packages

4. **Enable deployment**
   - Configure staging environment
   - Add deployment servers
   - Test deployment locally

5. **Optimize**
   - Review build times
   - Configure caching
   - Reduce unnecessary jobs

---

## 🔗 Important Links

- 📖 [Full VC++ Setup Guide](VCPP-CI-CD-SETUP.md)
- 📚 [GitHub Actions Documentation](https://docs.github.com/actions)
- 📝 [Lesson 1: Core Concepts](01-core-concepts.md)
- 💡 [Quick Reference](QUICK-REFERENCE.md)

---

## ⚡ Example: Your First Release

```bash
# 1. Make some code changes
# 2. Commit locally
git add .
git commit -m "v1.0.0: First release"

# 3. Create git tag
git tag v1.0.0

# 4. Push
git push origin v1.0.0

# 5. Go to GitHub → Releases → "Create release from tag"
# 6. Fill in details and publish

# 7. Watch Actions tab - workflows run automatically
# 8. In 15-20 minutes:
#    ✓ Build complete
#    ✓ Tests passed
#    ✓ Binaries signed
#    ✓ Packages created
#    ✓ Release published
```

---

💡 **Pro Tips:**
- Start with just the main CI workflow
- Test locally before committing
- Use staging environment before production
- Keep secrets secure
- Monitor workflow execution times
- Share workflows with your team

---

**Ready? Start with Step 1 above!** 🚀
