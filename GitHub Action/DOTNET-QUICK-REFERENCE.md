# ⚡ C# GitHub Actions - Quick Reference

## Configuration at a Glance

### Essential Configuration

```yaml
# In .github/workflows/dotnet-ci-cd-main.yml

env:
  DOTNET_VERSION: '8.0.x'              # or 7.0.x, 6.0.x
  SOLUTION_FILE: 'YourSolution.sln'    # Your .sln file
  PROJECT_FILE: 'src/Your.csproj'      # Main project
  TEST_PROJECT_FILE: 'tests/Tests.csproj'  # Test project
  CONFIGURATION: 'Release'              # or 'Debug'
```

---

## Quick Command Reference

### Local Development

```bash
# Build solution
dotnet build

# Build specific configuration
dotnet build -c Release

# Run tests
dotnet test

# Run specific test project
dotnet test tests/MyProject.Tests.csproj

# Generate code coverage
dotnet test /p:CollectCoverageRatio=true

# Format code
dotnet format

# Add package
dotnet add package NuGetPackageName

# Publish application
dotnet publish -c Release -o ./publish
```

### GitHub Actions Workflow Triggers

```bash
# Trigger CI on push (automatic)
git push origin main

# Trigger CI on PR (automatic)
# Create PR on GitHub

# Manual workflow trigger
# Go to Actions → Select workflow → "Run workflow"

# Trigger via tag (releases)
git tag v1.0.0
git push origin v1.0.0
```

---

## Workflow Triggers Table

| Trigger | Workflow | Action |
|---------|----------|--------|
| `push` to `main` | CI/CD | Build → Test → Package |
| `push` to `develop` | CI/CD | Build → Test → Package |
| `pull_request` | CI/CD | Build → Test (no package) |
| Release published | Code Signing | Build → Sign → Release |
| Release published | Deployment | Deploy to staging → production |
| Manual (workflow_dispatch) | All | Manually triggered |

---

## GitHub Secrets Required

### For Basic CI/CD

```
None required!
```

### For Code Signing (Optional)

```
SIGNING_CERTIFICATE_BASE64 = [Base64 encoded .pfx]
SIGNING_CERTIFICATE_PASSWORD = [certificate password]
```

### For NuGet Publishing (Optional)

```
NUGET_API_KEY = [your api key from nuget.org]
```

### For SonarQube Analysis (Optional)

```
SONAR_TOKEN = [your SonarQube token]
```

### For Deployment (Optional)

```
DEPLOYMENT_SERVER_HOST = your.server.com
DEPLOYMENT_SERVER_USER = admin
DEPLOYMENT_SERVER_PASSWORD = [password]
```

---

## Environment Setup Checklist

```
✓ .NET SDK installed locally (7.0+ or 8.0+)
✓ Solution builds locally: dotnet build
✓ Tests run locally: dotnet test
✓ Repository cloned to .github/workflows/
✓ dotnet-ci-cd-main.yml copied
✓ dotnet-code-signing-release.yml copied
✓ dotnet-deployment.yml copied
✓ SOLUTION_FILE configured in workflow
✓ PROJECT_FILE configured in workflow
✓ TEST_PROJECT_FILE configured in workflow
✓ Committed to GitHub
✓ Workflow runs successfully
```

---

## Workflow Overview

### Main CI/CD Workflow

```
Input:  git push
        ↓
     [Analyze]           5 min
        ↓
  [Build Debug]          5 min
  [Build Release]        5 min (parallel)
        ↓
     [Test]              3 min
        ↓
   [Coverage]            2 min
        ↓
   [Package]             2 min
        ↓
    [Summary]            1 min
        ↓
Output: Artifacts → Actions artifacts tab
```

**Total: ~20 minutes (first run slower)**

### Release Workflow

```
Input:  Create GitHub Release (tag v1.0.0)
        ↓
  [Build Release]        5 min
        ↓
  [Sign & Package]       5 min
        ↓
 [Publish Release]       2 min
        ↓
Output: GitHub Release + NuGet published
```

**Total: ~12 minutes**

### Deployment Workflow

```
Input:  Release published or manual trigger
        ↓
    [Prepare]            2 min
        ↓
   [Validate]            2 min
        ↓
 [Deploy Staging] (auto) 5 min
        ↓
[Deploy Production]      5 min
        (requires approval)
        ↓
    [Notify]             1 min
        ↓
Output: Deployment completed
```

**Total: ~15 minutes**

---

## Configuration Quick Reference

### Minimal Configuration (Just CI)

```yaml
DOTNET_VERSION: '8.0.x'
SOLUTION_FILE: 'MySolution.sln'
PROJECT_FILE: 'src/MyApp/MyApp.csproj'
TEST_PROJECT_FILE: 'tests/MyApp.Tests/MyApp.Tests.csproj'
```

**Result**: CI runs automatically on every push

### With Code Signing

```yaml
# Add to workflow:
env:
  SIGNING_CERTIFICATE_BASE64: ${{ secrets.SIGNING_CERTIFICATE_BASE64 }}
  SIGNING_CERTIFICATE_PASSWORD: ${{ secrets.SIGNING_CERTIFICATE_PASSWORD }}

# Add to GitHub Secrets
```

**Result**: Releases are automatically signed

### With NuGet Publishing

```yaml
# Add to workflow:
env:
  NUGET_API_KEY: ${{ secrets.NUGET_API_KEY }}

# Add to GitHub Secrets
```

**Result**: NuGet packages published automatically

---

## Common Configurations

### .NET Version Selection

```yaml
# Latest .NET 8
DOTNET_VERSION: '8.0.x'

# .NET 7
DOTNET_VERSION: '7.0.x'

# .NET 6 (LTS)
DOTNET_VERSION: '6.0.x'
```

### Build Configurations

```yaml
# Release builds (optimized)
CONFIGURATION: 'Release'

# Debug builds (with symbols)
CONFIGURATION: 'Debug'
```

### Test Framework Detection (Automatic)

```
✓ xUnit.net       (auto-detected)
✓ NUnit 3.x       (auto-detected)
✓ MSTest          (auto-detected)
```

---

## Status Badges

Add to README.md:

```markdown
[![Build Status](https://github.com/yourrepo/actions/workflows/dotnet-ci-cd-main.yml/badge.svg)](https://github.com/yourrepo/actions)
```

---

## Troubleshooting Quick Fixes

| Issue | Solution |
|-------|----------|
| Solution not found | Update `SOLUTION_FILE` with correct path |
| Tests not running | Verify `TEST_PROJECT_FILE` path exists |
| Build timeout | Split large solutions into smaller builds |
| NuGet restore fails | Check internet connection, NuGet sources |
| Code signing fails | Verify certificate Base64 format valid |
| Deployment fails | Check server credentials and connectivity |

---

## Performance Tips

| Tip | Impact |
|-----|--------|
| Use NuGet caching | 40% faster builds |
| Parallel tests | Tests run faster |
| Split workflows | Can scale to larger projects |
| Reduce artifact retention | Saves storage |

---

## Decision Tree

**Q: Do you want automatic builds on every push?**
→ Yes: Use `dotnet-ci-cd-main.yml` ✓

**Q: Do you want to sign releases?**
→ Yes: Add secrets + use `dotnet-code-signing-release.yml` ✓

**Q: Do you want automatic deployment?**
→ Yes: Use `dotnet-deployment.yml` ✓

**Q: Do you want code analysis?**
→ Yes: Add `SONAR_TOKEN` secret ✓

**Q: Do you want approval gates for production?**
→ Yes: Production environment automatically requires approval ✓

---

## Essential Files Location

```
Your C# Project/
├── .github/workflows/
│   ├── dotnet-ci-cd-main.yml            ← Main CI/CD
│   ├── dotnet-code-signing-release.yml  ← Release signing
│   └── dotnet-deployment.yml            ← Deployment
│
├── src/
│   └── YourProject.csproj               ← Update in workflow
│
├── tests/
│   └── YourProject.Tests.csproj         ← Update in workflow
│
└── YourSolution.sln                     ← Update in workflow
```

---

## Getting Help

| Question | Answer |
|----------|--------|
| How do I set up CI? | Read: DOTNET-QUICK-START.md |
| How do I configure everything? | Read: DOTNET-CI-CD-SETUP.md |
| What's wrong with my build? | Check: Actions tab → workflow logs |
| How do I add code signing? | See: DOTNET-CI-CD-SETUP.md § Code Signing |
| How do I deploy? | See: DOTNET-CI-CD-SETUP.md § Deployment |

---

## Key Shortcuts

```
GitHub Actions UI Shortcuts:
- Ctrl+K → Go to Actions tab
- Click workflow → See all runs
- Click run → See job logs
- Click job → See step output
```

---

## What Gets Automated

| Action | Automation |
|--------|-----------|
| `git push` | Build, test, package |
| Create tag `v1.0.0` | Build, sign, release |
| Create GitHub Release | Create signed packages |
| Release published | Auto-deploy to staging |
| Approve production | Auto-deploy to production |

---

## Quick Setup Recap

```bash
# 1. Copy workflows
cp examples/dotnet-*.yml .github/workflows/

# 2. Update paths
# Edit .github/workflows/dotnet-ci-cd-main.yml
# Change: SOLUTION_FILE, PROJECT_FILE, TEST_PROJECT_FILE

# 3. Commit & push
git add .github/workflows/
git commit -m "Add C# CI/CD"
git push

# 4. Monitor
# Go to: GitHub.com/yourrepo/actions
```

---

## Environment Variables Reference

```yaml
# Standard variables (available in all workflows)
${{ github.repository }}      # owner/repo
${{ github.sha }}             # commit hash
${{ github.ref }}             # branch name
${{ github.actor }}           # username
${{ github.run_number }}      # workflow run #
${{ github.run_id }}          # workflow ID

# Secrets (must add to GitHub)
${{ secrets.SIGNING_CERTIFICATE_BASE64 }}
${{ secrets.SIGNING_CERTIFICATE_PASSWORD }}
${{ secrets.NUGET_API_KEY }}
${{ secrets.SONAR_TOKEN }}
```

---

## For Complete Documentation

👉 See: **[DOTNET-CI-CD-SETUP.md](DOTNET-CI-CD-SETUP.md)**

For quick start: **[DOTNET-QUICK-START.md](DOTNET-QUICK-START.md)**

---

**Last Updated**: March 2026
**Status**: Complete & Tested ✅
