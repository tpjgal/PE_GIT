# 📘 C# GitHub Actions CI/CD - Complete Setup Guide

Comprehensive guide for setting up production-grade GitHub Actions for C# projects.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [Workflow Configuration](#workflow-configuration)
4. [Understanding the Workflows](#understanding-the-workflows)
5. [Advanced Configuration](#advanced-configuration)
6. [Troubleshooting](#troubleshooting)
7. [Best Practices](#best-practices)
8. [Security](#security)

---

## Prerequisites

### Required Software

- ✅ .NET SDK 7.0 or later (or 8.0 for latest)
- ✅ GitHub account with repository
- ✅ Git installed locally
- ✅ Visual Studio / VS Code (optional, for development)

### Verify Prerequisites

```bash
# Check .NET version
dotnet --version

# Check that solution builds
dotnet build YourSolution.sln

# Check that tests run
dotnet test
```

### Repository Requirements

- ✅ GitHub repository (public or private)
- ✅ Main branch or develop branch
- ✅ C# solution with projects
- ✅ Unit tests project (optional but recommended)

---

## Initial Setup

### Step 1: Clone or Download Workflows

Download these 3 files from the examples folder:

```
dotnet-ci-cd-main.yml
dotnet-code-signing-release.yml
dotnet-deployment.yml
```

Or clone the repository:

```bash
git clone <repo-url>
```

### Step 2: Create Workflows Directory

In your C# project repository:

```bash
mkdir -p .github/workflows
```

### Step 3: Copy Workflows

```bash
# Copy from examples folder to your repository
cp examples/dotnet-*.yml .github/workflows/
```

Verify files are in place:

```
.github/
└── workflows/
    ├── dotnet-ci-cd-main.yml              (600+ lines)
    ├── dotnet-code-signing-release.yml    (500+ lines)
    └── dotnet-deployment.yml              (400+ lines)
```

### Step 4: Update Project Paths

Edit `.github/workflows/dotnet-ci-cd-main.yml`:

Find these lines (approximately line 12-16):

```yaml
env:
  DOTNET_VERSION: '8.0.x'
  SOLUTION_FILE: 'YourSolution.sln'              # ← CHANGE THIS
  PROJECT_FILE: 'src/YourProject.csproj'         # ← CHANGE THIS
  TEST_PROJECT_FILE: 'tests/YourProject.Tests.csproj'  # ← CHANGE THIS
```

**Update to your actual paths:**

```yaml
env:
  DOTNET_VERSION: '8.0.x'
  SOLUTION_FILE: 'MyApp.sln'
  PROJECT_FILE: 'src/MyApp/MyApp.csproj'
  TEST_PROJECT_FILE: 'src/MyApp.Tests/MyApp.Tests.csproj'
```

**Tips:**
- Find your solution: `find . -name "*.sln" -type f`
- Find your project: `find . -name "*.csproj" -type f`

### Step 5: Update Other Workflows

Edit `.github/workflows/dotnet-code-signing-release.yml`:

```yaml
env:
  PROJECT_FILE: 'src/MyApp/MyApp.csproj'  # ← CHANGE
```

### Step 6: Test Locally First

Before pushing, verify locally:

```bash
# Build your solution
dotnet build

# Run your tests
dotnet test

# Check for any build warnings
# Fix any critical warnings
```

### Step 7: Commit & Push

```bash
git add .github/workflows/
git commit -m "feat: Add C# GitHub Actions CI/CD"
git push origin main
```

### Step 8: Monitor First Run

1. Go to GitHub repository
2. Click **Actions** tab
3. Watch your first workflow run
4. Check logs for any errors

---

## Workflow Configuration

### Workflow 1: Main CI/CD Pipeline

**File**: `dotnet-ci-cd-main.yml`

**Triggers**:
```yaml
on:
  push:
    branches: [ main, develop, 'release/**' ]
  pull_request:
    branches: [ main, develop ]
  workflow_dispatch:  # Manual trigger
```

**Stages**:

```
1. Analyze          → SonarQube/StyleCop analysis
2. Build (×2)       → Debug & Release configurations
3. Test             → Unit tests with coverage
4. Coverage         → Generate coverage reports
5. Package          → Create NuGet & ZIP packages
6. Summary          → Report results
```

**Configuration**:

```yaml
env:
  DOTNET_VERSION: '8.0.x'
  SOLUTION_FILE: 'YourSolution.sln'
  PROJECT_FILE: 'src/YourProject.csproj'
  TEST_PROJECT_FILE: 'tests/YourProject.Tests.csproj'
  CONFIGURATION: 'Release'
```

**Duration**: ~20 minutes (first run slower due to tool download)

### Workflow 2: Code Signing & Release

**File**: `dotnet-code-signing-release.yml`

**Triggers**:
```yaml
on:
  release:
    types: [published]
  workflow_dispatch:
```

**Stages**:

```
1. Build Release    → Compile release version
2. Sign & Package   → Code sign & create packages
3. Publish Release  → Publish to GitHub Releases & NuGet
```

**Configuration**:

```yaml
env:
  DOTNET_VERSION: '8.0.x'
  PROJECT_FILE: 'src/YourProject.csproj'
```

**Requirements**:
- Code signing certificate (optional, skipped if not configured)
- NuGet API key (optional, for NuGet publishing)

### Workflow 3: Multi-Stage Deployment

**File**: `dotnet-deployment.yml`

**Triggers**:
```yaml
on:
  release:
    types: [published]
  workflow_run:
    workflows: ["C# CI/CD Pipeline"]
    types: [completed]
  workflow_dispatch:
```

**Stages**:

```
1. Prepare          → Validate package
2. Validate         → Pre-deployment checks
3. Staging          → Deploy to staging (auto)
4. Production       → Deploy to prod (approval required)
5. Notify           → Send notifications
```

**Environments**:
- `staging` - Automatic deployment
- `production` - Requires manual approval

---

## Understanding the Workflows

### Main CI/CD Workflow Execution

```yaml
.github/workflows/dotnet-ci-cd-main.yml

├── Analyze (Ubuntu)
│   ├── Checkout code
│   ├── Setup .NET 8.0
│   ├── Restore NuGet packages
│   ├── Run SonarQube analysis (optional)
│   └── Run StyleCop analysis
│
├── Build (Windows, ×2 configs)
│   ├── Debug build
│   ├── Release build
│   ├── Cache NuGet packages
│   └── Upload build artifacts
│
├── Test (Ubuntu)
│   ├── Run xUnit/NUnit tests
│   ├── Collect test coverage
│   ├── Generate test reports (TRX format)
│   └── Upload test artifacts
│
├── Coverage (Ubuntu)
│   ├── Generate HTML coverage reports
│   ├── Comment on PR with metrics
│   └── Upload coverage artifacts
│
├── Package (Windows)
│   ├── Publish release build
│   ├── Create NuGet package (.nupkg)
│   ├── Create symbol package (.snupkg)
│   ├── Create ZIP archive
│   ├── Generate SHA256 checksums
│   └── Upload package artifacts
│
└── Summary (Ubuntu)
    ├── Generate build summary
    ├── Post results to Actions
    └── Notify on failure
```

**Total Duration**: 20-25 minutes (first run) → 15 minutes (subsequent)

### Test Results Processing

The pipeline automatically:

1. **Discovers tests** - Finds all test methods
2. **Runs tests** - Executes in parallel
3. **Collects coverage** - Records code coverage data
4. **Generates reports** - HTML and Cobertura XML
5. **Comments on PR** - Posts results to pull requests
6. **Archives results** - Stores for 30 days

---

## Advanced Configuration

### Code Signing Setup

#### Step 1: Obtain Code Signing Certificate

```bash
# Export certificate
# In Windows:
# - Certificate Manager → Personal → Certificates
# - Right-click certificate → All Tasks → Export
# - Format: PKCS #12 (.pfx) with password
```

#### Step 2: Convert to Base64

```powershell
# Windows PowerShell
$cert = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes("C:\path\to\cert.pfx"))
$cert | Out-File -FilePath "cert-base64.txt"
```

#### Step 3: Add Secrets to GitHub

```
Repository → Settings → Secrets and variables → Actions

Add:
  Name: SIGNING_CERTIFICATE_BASE64
  Value: [paste Base64 content]
  
  Name: SIGNING_CERTIFICATE_PASSWORD
  Value: [certificate password]
```

#### Step 4: Verify in Workflow

The workflow will automatically:
- Import certificate
- Sign all DLLs and EXEs
- Verify signatures
- Cleanup sensitive files

### NuGet Publishing

#### Setup NuGet API Key

```
Repository → Settings → Secrets → Actions

Add:
  Name: NUGET_API_KEY
  Value: [your nuget.org API key]
```

#### Enable Publishing

In `dotnet-code-signing-release.yml`, the publish step will:

```yaml
- name: Publish NuGet packages
  run: |
    dotnet nuget push "*.nupkg" \
      --api-key ${{ secrets.NUGET_API_KEY }} \
      --source https://api.nuget.org/v3/index.json
```

### SonarQube Code Analysis

#### Setup SonarCloud

```
1. Go to: https://sonarcloud.io
2. Sign in with GitHub
3. Create organization
4. Get organization key
5. Get project key
```

#### Add SonarQube Secret

```
Repository → Settings → Secrets

Add:
  Name: SONAR_TOKEN
  Value: [your SonarQube token]
```

#### Update Workflow

In `dotnet-ci-cd-main.yml`, update:

```yaml
- name: Run SonarQube analysis
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: |
    dotnet sonarscanner begin \
      /k:"YourOrg/YourProject" \
      /d:sonar.host.url="https://sonarcloud.io" \
      /d:sonar.login="${{ secrets.SONAR_TOKEN }}"
```

---

## Troubleshooting

### Build Failures

#### Error: "Solution file not found"

```
Error: Could not find file 'YourSolution.sln'
```

**Fix**: Update `SOLUTION_FILE` to correct path

```bash
# Find your solution
find . -name "*.sln" -type f

# Update in workflow
SOLUTION_FILE: 'path/to/YourSolution.sln'
```

#### Error: "Project file not found"

```
Error: Could not find project file
```

**Fix**: Verify project path

```bash
# Check if file exists
test -f "src/YourProject.csproj" && echo "Found" || echo "Not found"

# List projects
find . -name "*.csproj" -type f
```

### Test Failures

#### Error: "Tests project not found"

**Fix**: Ensure test project exists

```bash
# Verify test project
ls -la tests/YourProject.Tests.csproj

# Run tests locally
dotnet test
```

#### Error: "Test collection failed"

**Check**:
- Tests use xUnit, NUnit, or MSTest
- Test classes have proper attributes
- No syntax errors in tests

**Run locally**:
```bash
dotnet test --logger "console;verbosity=detailed"
```

### Coverage Report Issues

#### Error: "Coverage file not found"

**Fix**: Ensure tests are configured for coverage

Create `runsettings.xml` in solution root:

```xml
<?xml version="1.0" encoding="utf-8"?>
<RunSettings>
  <DataCollectionRunSettings>
    <DataCollectors>
      <DataCollector friendlyName="XPlat code coverage">
        <Configuration>
          <Format>cobertura</Format>
        </Configuration>
      </DataCollector>
    </DataCollectors>
  </DataCollectionRunSettings>
</RunSettings>
```

### Deployment Issues

#### Error: "Deployment failed"

**Check**:
- Deployment server credentials correct
- Network connectivity to server
- Required ports open (443, 22, 3389)

**Fix**: Test connection manually

```bash
# Test SSH connectivity
ssh -i key.pem user@server.com

# Or test RDP connectivity
mstsc /v:server.com
```

#### Error: "Approval not granted"

**Fix**: Manually approve in GitHub

```
Actions → Workflow run → Review deployments
→ Select environment → "Approve and deploy"
```

---

## Best Practices

### 1. Development Workflow

**Recommended branch strategy**:

```
main (production)
 ↓
develop (staging)
 ↓
feature/* (development)
```

**Workflow**:
```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes, commit
git commit -m "feat: add feature"

# Create PR to develop
git push origin feature/my-feature
# (then create PR on GitHub)

# After PR approved
git merge --squash
# (or merge via GitHub UI)
```

### 2. Commit Messages

Follow conventional commits:

```
feat: Add new feature
fix: Fix bug
docs: Update documentation
test: Add tests
chore: Update dependencies
```

### 3. Code Quality

```bash
# Before committing
dotnet format
dotnet build /p:EnforceCodeStyleInBuild=true
dotnet test
```

### 4. Release Process

```bash
# Create release tag
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Create GitHub Release
# (Workflow triggers automatically)
```

### 5. Monitoring

**Set up notifications**:

1. GitHub → Watch repository
2. Actions → Subscribe to workflow notifications
3. Monitor email for workflow failures

---

## Security

### Secrets Management

**Do's**:
- ✅ Use GitHub secrets for all credentials
- ✅ Rotate secrets regularly
- ✅ Use least privilege principle
- ✅ Audit secret access

**Don'ts**:
- ❌ Commit secrets to repository
- ❌ Log secrets in workflow output
- ❌ Share secrets via email
- ❌ Use one secret for multiple services

### Branch Protection

**Recommended settings**:

```
Repository → Settings → Branches

main branch:
  ✓ Require status checks to pass
  ✓ Require branches up to date
  ✓ Require code review (1+ approvals)
  ✓ Dismiss stale reviews
  ✓ Require status checks
  ✓ Include administrators
```

### Certificate Security

```
Storage:
  ✓ Store certificate as Base64 in GitHub secrets
  ✓ Store password separately in GitHub secrets
  ✓ Use short-lived certificates (2-3 years)

Usage in workflow:
  ✓ Import only when needed
  ✓ Cleanup after use
  ✓ Don't log certificate details
  ✓ Verify signatures before release
```

### Access Control

**Repository permissions**:

```
- Public repos: CI only, no secrets in logs
- Private repos: Can use deployment secrets
- Teams: Use GitHub organization permissions
- Approvals: Require approval for production deployments
```

---

## Performance Optimization

### NuGet Package Caching

**Implemented automatically** in workflow:

```yaml
- name: Cache NuGet packages
  uses: actions/cache@v4
  with:
    path: ~/.nuget/packages
    key: ${{ runner.os }}-nuget-${{ hashFiles('**/packages.lock.json') }}
```

**Result**: 40% faster subsequent builds

### Parallel Testing

**Automatic** - tests run in parallel:

```yaml
- name: Run unit tests
  run: |
    dotnet test \
      --logger "trx" \
      --collect:"XPlat Code Coverage"
```

### Build Optimization

**For faster builds**:

```bash
# Use incremental builds
dotnet build --incremental

# Skip unused projects
dotnet build --projects src/MyProject.csproj

# Parallel build
dotnet build /m
```

---

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [.NET CLI Documentation](https://learn.microsoft.com/en-us/dotnet/core/tools/)
- [xUnit.net](https://xunit.net)
- [SonarCloud](https://sonarcloud.io)

---

## Support

**For issues**:

1. Check [Troubleshooting](#troubleshooting) section
2. Review workflow logs in GitHub Actions tab
3. See [DOTNET-QUICK-REFERENCE.md](DOTNET-QUICK-REFERENCE.md)
4. Create GitHub issue with logs

---

Last updated: March 2026
