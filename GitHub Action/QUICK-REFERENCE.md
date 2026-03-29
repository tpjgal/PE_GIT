# GitHub Actions Quick Reference

## Getting Started Checklist

- [ ] Read README.md for overview
- [ ] Complete Lesson 1: Core Concepts
- [ ] Complete Lesson 2: Workflow Anatomy
- [ ] Try hello-world.yml example
- [ ] Create your first workflow

---

## File Locations

```
Your Repository
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── deploy.yml
│   │   └── ...
│   └── actions/
│       └── my-action/
│           └── action.yml
```

**Remember:** All workflow files go in `.github/workflows/`

---

## Basic Workflow Template

```yaml
name: Workflow Name

on: push              # Trigger

env:                  # Environment variables
  VAR: value

jobs:
  job-name:           # Job name
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: echo "Hello World"
```

---

## Triggers (on:)

```yaml
on: push                          # Any push
on: pull_request                  # Any PR
on:
  push:
    branches: [ main ]            # Specific branch
  pull_request:
    branches: [ main ]

on:
  schedule:
    - cron: '0 * * * *'           # Every hour

on:
  workflow_dispatch:              # Manual trigger
  release:
    types: [ published ]          # On release

on:
  push:
    paths:
      - 'src/**'                  # Only if src/ changed
```

---

## Jobs & Steps

```yaml
jobs:
  job-name:
    runs-on: ubuntu-latest        # or: windows-latest, macos-latest
    timeout-minutes: 30           # Max runtime
    
    strategy:
      matrix:
        node: [16, 18, 20]        # Run 3 times
    
    steps:
      - name: Step name
        uses: owner/action@v1     # Use action
        run: command              # OR run command
        if: condition             # Optional
        with:
          key: value              # Action inputs
```

---

## Common Conditions (if:)

```yaml
if: github.ref == 'refs/heads/main'
if: github.event_name == 'push'
if: success()                       # Previous succeeded
if: failure()                       # Previous failed
if: always()                        # Always run
if: contains(github.ref, 'release')
```

---

## Important Variables

```yaml
${{ github.repository }}          # owner/repo
${{ github.ref }}                 # Full: refs/heads/main
${{ github.ref_name }}            # Short: main
${{ github.sha }}                 # Commit hash
${{ github.actor }}               # User
${{ github.event_name }}          # Trigger type
${{ github.workspace }}           # Working directory
${{ runner.os }}                  # ubuntu, windows, macos
${{ env.VAR }}                    # Environment variable
${{ secrets.SECRET }}             # Repository secret
${{ matrix.node }}                # Matrix variable
```

---

## Essential Actions

```yaml
# Checkout code
- uses: actions/checkout@v3

# Setup Node.js
- uses: actions/setup-node@v3
  with:
    node-version: 18
    cache: npm

# Setup Python
- uses: actions/setup-python@v4
  with:
    python-version: '3.11'
    cache: pip

# Upload files
- uses: actions/upload-artifact@v3
  with:
    name: artifact-name
    path: path/to/files

# Download files
- uses: actions/download-artifact@v3
  with:
    name: artifact-name

# Setup caching
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
```

---

## Secrets Management

```yaml
# Create secret in Settings → Secrets → Actions

# Use in workflow
env:
  API_KEY: ${{ secrets.API_KEY }}

# Use in step
- run: curl -H "Auth: ${{ secrets.TOKEN }}" https://api.example.com
```

---

## Useful Patterns

### Run job only on main
```yaml
deploy:
  if: github.ref == 'refs/heads/main'
```

### Skip workflow for docs changes
```yaml
on:
  push:
    paths-ignore:
      - '**.md'
      - 'docs/**'
```

### Matrix with Node versions
```yaml
strategy:
  matrix:
    node: [16, 18, 20]
```

### Make jobs sequential
```yaml
build:
  runs-on: ubuntu-latest

test:
  needs: build          # Wait for build
```

### Pass data between jobs
```yaml
build:
  outputs:
    version: ${{ steps.version.outputs.result }}

deploy:
  needs: build
  steps:
    - run: echo ${{ needs.build.outputs.version }}
```

---

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Workflow not running | Check file is in `.github/workflows/` and syntax is valid |
| Secrets not working | Use `${{ secrets.NAME }}`, not plain text |
| Matrix not working | Check indentation, use `strategy: matrix:` |
| Jobs not running in order | Use `needs: job-name` |
| Permission denied | Check `permissions:` section |
| Slow workflow | Enable caching with `cache: npm` |

---

## Performance Tips

✅ Cache dependencies
```yaml
- uses: actions/setup-node@v3
  with:
    cache: npm
```

✅ Run tests only on latest version
```yaml
strategy:
  matrix:
    node: [18]
```

✅ Skip for documentation-only changes
```yaml
on:
  push:
    paths-ignore: ['**.md']
```

✅ Use fail-fast for quick feedback
```yaml
strategy:
  fail-fast: true
```

---

## Learn More

**Current Lesson:** Check the numbered lesson files (01-*, 02-*, etc.)

**Examples:** Check the `examples/` directory for complete workflows

**Official Docs:** https://docs.github.com/actions

**Marketplace:** https://github.com/marketplace?type=actions

---

## Quick Test

1. Create `.github/workflows/test.yml`
2. Add this content:
```yaml
name: Quick Test

on: push

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: echo "GitHub Actions works!"
```
3. Push to your repository
4. Check Actions tab to see it run!

---

## Next: Choose Your Path

- Start with **Lesson 1** if you're new
- Jump to **Lesson 5** if you want to use marketplace actions
- Look at **examples/** if you want ready-to-use workflows
- Read **07-best-practices.md** when you need optimization tips

---

Happy automating! 🚀
