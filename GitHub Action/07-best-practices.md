# Lesson 7: Best Practices

## What You'll Learn
- Performance optimization
- Security best practices
- Workflow maintenance
- Common patterns
- Troubleshooting tips

---

## 7.1 Performance Optimization

### 1. Use Caching

```yaml
# ❌ BAD - No caching
- uses: actions/setup-node@v3
  with:
    node-version: 18
- run: npm install

# ✅ GOOD - With caching
- uses: actions/setup-node@v3
  with:
    node-version: 18
    cache: npm

# Manual caching for other tools
- uses: actions/cache@v3
  with:
    path: ~/.gradle/caches
    key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*') }}
    restore-keys: |
      ${{ runner.os }}-gradle-
```

### 2. Optimize Matrix Builds

```yaml
# ❌ BAD - Tests on all combinations
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    node: [16, 18, 20]
    python: [3.8, 3.9, 3.10]  # 3 * 3 * 3 = 27 jobs!

# ✅ GOOD - Test on primary config, expand selectively
strategy:
  matrix:
    node: [16, 18, 20]
  include:
    - node: 18
      os: windows-latest
    - node: 18
      os: macos-latest
```

### 3. Parallel Jobs Efficiently

```yaml
# ❌ BAD - Wait for all tests before building
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [16, 18, 20]
  
  build:
    needs: test          # Waits for ALL test jobs
    runs-on: ubuntu-latest

# ✅ GOOD - Build as soon as one test passes
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [18]       # Just test latest
  
  build:
    needs: test
    runs-on: ubuntu-latest
```

### 4. Fail Fast

```yaml
strategy:
  matrix:
    node: [16, 18, 20]
  fail-fast: true        # Stop if any job fails
```

### 5. Early Job Exit

```yaml
jobs:
  check-format:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm run lint
      # Stop here if linting fails - don't run tests

  test:
    needs: check-format    # Only after lint passes
    runs-on: ubuntu-latest
    steps:
      - run: npm test
```

---

## 7.2 Security Best Practices

### 1. Never Hardcode Secrets

```yaml
# ❌ WRONG
env:
  API_KEY: sk_test_1234567890

# ✅ RIGHT
env:
  API_KEY: ${{ secrets.API_KEY }}
```

### 2. Use GitHub Secrets

```yaml
steps:
  - name: Deploy with secret
    run: |
      SECRET_API_KEY=${{ secrets.API_KEY }}
      curl -H "Authorization: Bearer $SECRET_API_KEY" https://api.example.com
```

**How to create secrets:**
- Go to Settings → Secrets → Actions
- Click "New repository secret"
- Enter name and value
- Use via `${{ secrets.SECRET_NAME }}`

### 3. Limit Permissions

```yaml
# ✅ GOOD - Minimal permissions
permissions:
  contents: read
  pull-requests: write

jobs:
  comment:
    permissions:
      pull-requests: write
    steps:
      - uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: 'Comment'
            })
```

### 4. Use Trusted Actions

```yaml
# ✅ GOOD - Official GitHub action
uses: actions/checkout@v3

# ✅ GOOD - Specific version
uses: owner/action@v1

# ❌ RISKY - Unpinned version
uses: untrusted-author/random-action@main

# ❌ RISKY - Random action
uses: random-username/random-repo@main
```

### 5. Audit Dependencies

```yaml
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      # Check for vulnerable dependencies
      - name: Run npm audit
        run: npm audit --audit-level=moderate
      
      # SAST scanning
      - name: Run Trivy security scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
```

### 6. Protect Sensitive Output

```yaml
steps:
  - name: API key operation
    run: |
      API_KEY=${{ secrets.API_KEY }}
      # Output will be masked automatically
      echo "Key: $API_KEY"
      
      # For variables, add manually
      echo "::add-mask::${{ secrets.API_KEY }}"
```

### 7. Use Environments for Approvals

```yaml
jobs:
  deploy-prod:
    environment:
      name: production
      # Optional: add restrictions
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to production"
```

**In Settings → Environments** you can:
- Require approval before deployment
- Set reviewers
- Set environment variables
- Set deployment branches

---

## 7.3 Workflow Maintenance

### 1. Use Descriptive Names

```yaml
# ❌ BAD
name: CI

# ✅ GOOD
name: Node.js CI - Lint, Test, Build
```

### 2. Add Comments

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      # Set up Node.js environment
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: npm
      
      # Install dependencies
      - run: npm ci
      
      # Run tests with coverage
      - run: npm test -- --coverage
```

### 3. Use Step IDs for Reference

```yaml
steps:
  - name: Build app
    id: build
    run: npm run build

  - name: Check build size
    if: steps.build.conclusion == 'success'
    run: du -sh dist/
```

### 4. Document Workflow

```yaml
name: Production Deployment

# Workflow does:
# 1. Builds Docker image
# 2. Runs tests
# 3. Deploys to production
# 4. Runs health checks
# 5. Notifies Slack

on:
  push:
    tags: [ 'v*' ]
```

### 5. Version Your Actions

```yaml
# ✅ GOOD - Specific major version
uses: actions/checkout@v3
uses: actions/setup-node@v3

# ✅ ALSO GOOD - Specific patch version
uses: actions/checkout@v3.5.0

# ❌ AVOID - Floating version
uses: actions/checkout@latest
uses: actions/checkout@v3
```

### 6. Reusable Workflows

Create `.github/workflows/test.yml`:
```yaml
name: Test

on:
  workflow_call:
    inputs:
      node-version:
        type: string
        default: '18'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ inputs.node-version }}
      - run: npm ci
      - run: npm test
```

Use in another workflow:
```yaml
name: Nightly Tests

on:
  schedule:
    - cron: '0 2 * * *'

jobs:
  test-node-16:
    uses: ./.github/workflows/test.yml
    with:
      node-version: '16'
  
  test-node-18:
    uses: ./.github/workflows/test.yml
    with:
      node-version: '18'
```

---

## 7.4 Common Patterns

### Pattern 1: Run X on Push, Y on PR

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm test

  lint:
    # Run comprehensive linting on push, basic on PR
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: |
          if [ "${{ github.event_name }}" = "push" ]; then
            npm run lint:strict
          else
            npm run lint
          fi
```

### Pattern 2: Run Only on Main Branch

```yaml
jobs:
  deploy:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: npm run deploy
```

### Pattern 3: Skip Workflow for Docs

```yaml
on:
  push:
    branches: [ main ]
    paths-ignore:
      - '**.md'
      - 'docs/**'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: npm test
```

### Pattern 4: Conditional Matrix

```yaml
strategy:
  matrix:
    include:
      - os: ubuntu-latest
        node: '18'
        primary: true
      
      - os: ubuntu-latest
        node: '20'
        primary: false
      
      - os: windows-latest
        node: '18'
        primary: false
```

### Pattern 5: Pass Data Between Jobs

```yaml
jobs:
  version:
    runs-on: ubuntu-latest
    outputs:
      next-version: ${{ steps.version.outputs.next }}
    steps:
      - id: version
        run: echo "next=${{ github.run_number }}" >> $GITHUB_OUTPUT

  build:
    needs: version
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building version ${{ needs.version.outputs.next-version }}"
```

---

## 7.5 Troubleshooting

### Issue 1: "Syntax Error in workflow file"

**Solution:**
- Check indentation (must be 2 spaces)
- Use online YAML validator
- Check GitHub's workflow validation (type in web editor)

```bash
# Local validation
brew install actionlint
actionlint .github/workflows/*.yml
```

### Issue 2: "Workflow not triggering on push"

**Checklist:**
- ✅ Branch matches trigger branch?
- ✅ File is in `.github/workflows/`?
- ✅ Workflow has `on: push`?
- ✅ Syntax is valid?
- ✅ Pushed to correct branch?

### Issue 3: "Permission denied - runner can't access"

**Solution:**
- Check token permissions
- Check repository secrets
- Verify `permissions:` section

```yaml
permissions:
  contents: write
  pull-requests: write
```

### Issue 4: "Action not found"

**Solution:**
```yaml
# Check exact syntax
uses: owner/repo@v1        # ✅ Correct format

# Common mistakes
uses: owner/repo           # ❌ Need version/branch
uses: repo@v1             # ❌ Need owner too
```

### Issue 5: "Timeout - workflow taking too long"

**Solution:**
```yaml
# Add timeout
timeout-minutes: 10

# Or for specific step
- run: long-running-command
  timeout-minutes: 30
```

### Debugging Tips

```yaml
# Print environment variables
- run: env | sort

# Print GitHub context
- uses: actions/github-script@v6
  with:
    script: console.log(JSON.stringify(context, null, 2))

# Enable debug logging
- run: npm test
  env:
    ACTIONS_STEP_DEBUG: true

# Save and inspect logs
- uses: actions/upload-artifact@v3
  if: always()
  with:
    name: logs
    path: logs/
```

---

## 7.6 Performance Benchmarks

### Typical Execution Times

| Task | Duration |
|------|----------|
| Start runner | 5-10 sec |
| Checkout code | 2-5 sec |
| npm install (uncached) | 30-60 sec |
| npm install (cached) | 5-10 sec |
| Run tests | varies |
| Build (uncached) | varies |
| Docker build/push | 2-5 min |

### Optimization Targets

✅ Cache dependencies (saves 30-60 seconds)
✅ Run tests in parallel (splits execution time)
✅ Skip unnecessary jobs (saves 20-30 seconds each)
✅ Use faster runners when possible

---

## 7.7 Monitoring and Alerts

### Set Up Notifications

```yaml
# Slack notification on failure
- name: Notify Slack
  if: failure()
  uses: slackapi/slack-github-action@v1.24.0
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "❌ Workflow failed: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
      }

# Email notification
- name: Send email
  if: failure()
  uses: davisnathaniel/action-send-email@v1
  with:
    server_address: ${{ secrets.EMAIL_SERVER }}
    username: ${{ secrets.EMAIL_USERNAME }}
    password: ${{ secrets.EMAIL_PASSWORD }}
    subject: "Workflow failed: ${{ github.repository }}"
    to: team@example.com
    from: ci@example.com
```

### Track Workflow Performance

```yaml
# Log execution time
- name: Log execution time
  run: |
    echo "Workflow started: ${{ github.event.created_at }}"
    echo "Current time: $(date)"
```

---

## 7.8 Workflow Template

Use this template for your workflows:

```yaml
# Descriptive name
name: CI/CD Pipeline

# Clear documentation
# Lints code, runs tests, builds app, and deploys

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

env:
  NODE_VERSION: 18

jobs:
  # Job 1: Quick checks
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: npm
      - run: npm ci
      - run: npm run lint

  # Job 2: Tests (depends on lint)
  test:
    needs: lint
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [16, 18, 20]
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node }}
          cache: npm
      - run: npm ci
      - run: npm test

  # Job 3: Build (depends on test)
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: npm
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v3
        with:
          name: dist
          path: dist/

  # Job 4: Deploy (depends on build, main only)
  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/download-artifact@v3
        with:
          name: dist
      - run: npm run deploy
      - name: Notify
        if: success()
        uses: slackapi/slack-github-action@v1.24.0
        with:
          webhook-url: ${{ secrets.SLACK_WEBHOOK }}
          payload: '{"text":"✅ Deployed successfully"}'
```

---

## Practice: Optimize Your Workflow

1. **Add caching** if not present
2. **Add timeouts** for long-running jobs
3. **Use step IDs** for conditional logic
4. **Add notifications** for failures
5. **Document** what the workflow does
6. **Test** on different scenarios (push, PR, etc.)

---

## Quiz

1. **How do you share secrets with actions?**
   - Via `${{ secrets.SECRET_NAME }}`

2. **What's the default permission level?**
   - Full access (specify minimal permissions explicitly)

3. **How do you make a job run only on main?**
   - `if: github.ref == 'refs/heads/main'`

4. **What's the best way to cache node_modules?**
   - Use `actions/setup-node@v3` with `cache: npm`

---

## Key Takeaways 🎯

✅ Cache dependencies to speed up builds
✅ Never hardcode secrets - always use `${{ secrets.* }}`
✅ Use minimum required permissions
✅ Pin action versions for stability
✅ Add timeouts for long-running jobs
✅ Document your workflows with comments
✅ Use environments for deployment gates
✅ Set up notifications for failures
✅ Profile and optimize regularly

---

## Congratulations! 🎉

You've completed the GitHub Actions Learning Guide!

### What You've Learned:
- ✅ GitHub Actions basics and core concepts
- ✅ Workflow file structure and YAML syntax
- ✅ Triggers: events, schedules, manual
- ✅ Jobs and steps execution models
- ✅ Using actions from marketplace
- ✅ 6 complete real-world workflow examples
- ✅ Performance optimization and security
- ✅ Best practices and troubleshooting

### Next Steps:
1. **Apply** what you learned to your project
2. **Create** your first workflow
3. **Experiment** with different triggers and actions
4. **Join** the GitHub community for support
5. **Keep learning** - GitHub constantly adds features

### Resources:
- [Official GitHub Actions Documentation](https://docs.github.com/actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [GitHub Community](https://github.community/)
- [Awesome GitHub Actions](https://github.com/sdras/awesome-actions)

### Pro Tips for Success:
- 📝 Start simple, add complexity gradually
- 🔒 Always treat secrets as sensitive
- 📊 Monitor workflow execution times
- 🤝 Share workflows with your team
- 💡 Document why you made certain choices

---

**Happy automating! 🚀**
