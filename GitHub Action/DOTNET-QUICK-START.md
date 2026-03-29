# 🚀 C# GitHub Actions CI/CD - Quick Start (5 Minutes)

Get your C# project running with GitHub Actions CI/CD in just 5 minutes!

## ⚡ Super Quick Setup

### Step 1: Copy Workflow Files (1 min)

```powershell
# Clone or download these files to your project
.github/
└── workflows/
    ├── dotnet-ci-cd-main.yml
    ├── dotnet-code-signing-release.yml
    └── dotnet-deployment.yml
```

### Step 2: Update Configuration (2 min)

Edit `dotnet-ci-cd-main.yml` and update these lines:

```yaml
env:
  SOLUTION_FILE: 'YourSolution.sln'          # ← Your .sln file
  PROJECT_FILE: 'src/YourProject.csproj'     # ← Main project
  TEST_PROJECT_FILE: 'tests/YourProject.Tests.csproj'  # ← Test project
```

And edit `dotnet-code-signing-release.yml`:

```yaml
env:
  PROJECT_FILE: 'src/YourProject.csproj'
```

### Step 3: Commit & Push (1 min)

```bash
git add .github/workflows/
git commit -m "Add C# GitHub Actions CI/CD"
git push
```

### Step 4: Watch It Run (1 min)

1. Go to your GitHub repository
2. Click **Actions** tab
3. Watch your first workflow run! ✅

---

## ✅ Verification Checklist

- [ ] .NET solution builds locally: `dotnet build`
- [ ] Tests run locally: `dotnet test`
- [ ] Repository has `.github/workflows/` folder
- [ ] All 3 YAML files copied
- [ ] Solution file name updated in workflows
- [ ] Project file name updated in workflows
- [ ] Pushed to GitHub

---

## 🎯 What Gets Automated

After setup, every time you **push** to GitHub:

1. ✅ **Code Analysis** - Automatic code quality checks
2. ✅ **Build** - Compiles Debug and Release configurations
3. ✅ **Unit Tests** - Runs all xUnit/NUnit tests
4. ✅ **Code Coverage** - Generates coverage reports
5. ✅ **Packaging** - Creates NuGet packages and ZIP files
6. ✅ **Summary** - Reports all results

**All in ~20 minutes** ⏱️

---

## 🔑 Common Workflows

### Workflow 1: Simple CI (Just Build & Test)

This happens **automatically**! Just push:

```bash
git push origin main
```

Result: Code analyzed → Built → Tested → Packaged

### Workflow 2: Create a Release

```bash
# Tag your code
git tag v1.0.0
git push origin v1.0.0

# Automatic: Code signed → NuGet published
```

### Workflow 3: Deploy to Production

```bash
# Create GitHub Release
# OR Manually trigger: Actions → Deploy → Run workflow

# Automatic: Deploy to staging → Manual approval → Deploy to production
```

---

## 📊 First Run Timeline

```
Initial push to GitHub:
├─ Code Analysis:      5 min  (Downloads tools first time)
├─ Build (×2):         10 min (Debug + Release)
├─ Tests:              3 min
├─ Coverage:           2 min
├─ Packaging:          2 min
└─ Summary:            1 min
───────────────────────────────
   TOTAL:             ~23 minutes

Subsequent pushes:     ~15 minutes (cache speeds it up)
```

---

## 🔧 Configuration Essentials

### Required (Must Do)

- [ ] Update `SOLUTION_FILE` - Your .sln filename
- [ ] Update `PROJECT_FILE` - Your main .csproj path
- [ ] Verify solution builds locally

### Optional (For Production)

- [ ] Add `SONAR_TOKEN` secret for code analysis
- [ ] Add code signing certificate (for releases)
- [ ] Configure deployment servers
- [ ] Set branch protection rules

---

## 📁 File Structure Expected

```
YourProject/
├── .github/
│   └── workflows/
│       ├── dotnet-ci-cd-main.yml
│       ├── dotnet-code-signing-release.yml
│       └── dotnet-deployment.yml
├── src/
│   └── YourProject.csproj          ← Update in workflow
├── tests/
│   └── YourProject.Tests.csproj    ← Update in workflow
├── YourSolution.sln                ← Update in workflow
└── ...
```

---

## 🎯 Next Steps (After First Run)

### Immediate (Within 1 hour)

1. ✅ First build should succeed
2. ✅ Check Actions tab for results
3. ✅ Review any warnings

### This Week

1. Read: **DOTNET-CI-CD-SETUP.md** (full configuration)
2. Optional: Configure code signing for releases
3. Optional: Set up deployment environments

### This Month

1. Run releases with code signing
2. Configure staging deployment
3. Configure production deployment

---

## 🐛 Troubleshooting

### Issue: Build fails with "Solution not found"

**Fix**: Update `SOLUTION_FILE` in workflow with correct filename

```yaml
SOLUTION_FILE: 'MySolution.sln'  # NOT 'YourSolution.sln'
```

### Issue: Tests not running

**Fix**: Ensure test project exists at configured path

```yaml
TEST_PROJECT_FILE: 'tests/MyProject.Tests.csproj'
```

Run locally to verify:
```bash
dotnet test tests/MyProject.Tests.csproj
```

### Issue: "Workflow failed" message

**Fix**: Click on Actions → Failed workflow → View logs

Look for red error messages in the logs to identify the issue.

### Issue: First run slow

**Normal!** First run downloads all tools. Subsequent runs use cache and run 40% faster.

---

## 📚 Learn More

| Next Step | Read This | Time |
|-----------|-----------|------|
| Understand workflows | **[Lesson 1: Core Concepts](01-core-concepts.md)** | 20 min |
| Configure release signing | **[DOTNET-CI-CD-SETUP.md](DOTNET-CI-CD-SETUP.md)** | 30 min |
| Troubleshoot issues | **[DOTNET-CI-CD-SETUP.md § Troubleshooting](DOTNET-CI-CD-SETUP.md)** | 10 min |
| Quick reference | **[DOTNET-QUICK-REFERENCE.md](DOTNET-QUICK-REFERENCE.md)** | 5 min |

---

## ✨ What You Now Have

✅ **Automatic CI/CD** - Build and test on every push
✅ **Code Quality** - Analysis and coverage reporting
✅ **Package Management** - NuGet packages auto-created
✅ **Release Automation** - One-click releases with signing
✅ **Deployment Pipeline** - Staging & production with approvals

---

## 🎉 You're Ready!

**Next action**: Push your first commit and watch the workflow run in the Actions tab!

```bash
git push
# Then go to: GitHub.com/yourrepo/actions
```

Questions? Check **[DOTNET-CI-CD-SETUP.md](DOTNET-CI-CD-SETUP.md)** for comprehensive documentation.

Happy automating! 🚀
