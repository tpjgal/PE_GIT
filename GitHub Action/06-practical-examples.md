# Lesson 6: Practical Examples

## What You'll Learn
- Real-world workflow patterns
- Complete, production-ready workflows
- Common use cases and solutions
- How to adapt examples to your needs

---

## 6.1 Node.js - Test and Build

### Complete Node.js CI Workflow

```yaml
name: Node.js CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest]
        node-version: [16, 18, 20]
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          cache: npm
      
      - name: Install dependencies
        run: npm ci
      
      - name: Lint code
        run: npm run lint
      
      - name: Run tests
        run: npm test
      
      - name: Upload coverage
        if: matrix.os == 'ubuntu-latest' && matrix.node-version == '18'
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

  build:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: npm
      
      - run: npm ci
      - run: npm run build
      
      - name: Store build output
        uses: actions/upload-artifact@v3
        with:
          name: dist
          path: dist/
          retention-days: 5
```

### package.json Scripts

```json
{
  "scripts": {
    "test": "jest",
    "lint": "eslint .",
    "build": "webpack",
    "dev": "webpack serve"
  }
}
```

---

## 6.2 Python - Test and Deploy

### Complete Python CI/CD

```yaml
name: Python CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  release:
    types: [published]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.8', '3.9', '3.10', '3.11']
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}
          cache: pip
      
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements-dev.txt
      
      - name: Lint with flake8
        run: |
          flake8 src/ --count --select=E9,F63,F7,F82 --show-source --statistics
      
      - name: Type check with mypy
        run: mypy src/
      
      - name: Test with pytest
        run: pytest --cov=src --cov-report=xml
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage.xml
          verbose: true

  build-and-publish:
    needs: test
    if: github.event_name == 'release'
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install build dependencies
        run: |
          python -m pip install build wheel twine
      
      - name: Build distribution
        run: python -m build
      
      - name: Publish to PyPI
        env:
          TWINE_USERNAME: __token__
          TWINE_PASSWORD: ${{ secrets.PYPI_API_TOKEN }}
        run: python -m twine upload dist/*
```

---

## 6.3 Docker - Build and Push

### Docker Image CI/CD

```yaml
name: Docker Build and Push

on:
  push:
    branches: [ main ]
    tags: [ 'v*' ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Log in to Container Registry
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha
      
      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

### Dockerfile Example

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

---

## 6.4 Release and Deployment

### Automated Release Workflow

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  create-release:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Generate changelog
        id: changelog
        run: |
          # Simple version: show commits since last tag
          CHANGES=$(git log $(git describe --tags --abbrev=0)..HEAD --oneline)
          echo "body=$CHANGES" >> $GITHUB_OUTPUT
      
      - name: Create GitHub Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          body: ${{ steps.changelog.outputs.body }}
          draft: false
          prerelease: false

  deploy-to-production:
    needs: create-release
    runs-on: ubuntu-latest
    environment: production
    
    steps:
      - uses: actions/checkout@v3
      
      # Deploy steps here (specific to your deployment)
      - name: Deploy
        run: |
          echo "Deploying ${{ github.ref }} to production"
          # Your deployment script/command
```

---

## 6.5 Scheduled Tasks

### Nightly Tests and Cleanup

```yaml
name: Maintenance Tasks

on:
  schedule:
    - cron: '0 2 * * *'              # Daily at 2 AM UTC
    - cron: '0 0 * * 0'              # Weekly at midnight Sunday
  workflow_dispatch:                 # Allow manual trigger

jobs:
  # Daily task
  nightly-test:
    runs-on: ubuntu-latest
    if: github.event.schedule == '0 2 * * *' || github.event_name == 'workflow_dispatch'
    
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: npm
      - run: npm ci
      - run: npm run test:e2e
      
      - name: Notify on failure
        if: failure()
        uses: slackapi/slack-github-action@v1.24.0
        with:
          webhook-url: ${{ secrets.SLACK_WEBHOOK }}
          payload: |
            {
              "text": "⚠️ Nightly tests failed!"
            }

  # Weekly task
  cleanup-artifacts:
    runs-on: ubuntu-latest
    if: github.event.schedule == '0 0 * * 0'
    
    steps:
      - name: Delete artifacts older than 30 days
        uses: geekyeggo/delete-artifact@v2
        with:
          min-age: 30d
```

---

## 6.6 Pull Request Automation

### PR Checks and Auto-Actions

```yaml
name: Pull Request Checks

on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  pull-requests: write
  contents: read

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: npm
      
      - run: npm ci
      - run: npm run lint
      - run: npm test
  
  size-check:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: npm
      
      - run: npm ci
      - run: npm run build
      
      - name: Check bundle size
        run: |
          SIZE=$(du -sh dist/ | cut -f1)
          echo "Build size: $SIZE"
          if [ $(du -s dist/ | cut -f1) -gt 5000 ]; then
            echo "⚠️ Build size exceeds 5MB limit"
            exit 1
          fi
  
  label-by-changed-files:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Add labels based on changes
        uses: actions/github-script@v6
        with:
          script: |
            const { data: files } = await github.rest.pulls.listFiles({
              owner: context.repo.owner,
              repo: context.repo.repo,
              pull_number: context.issue.number
            })
            
            const hasDocChanges = files.some(f => f.filename.startsWith('docs/'))
            const hasTestChanges = files.some(f => f.filename.includes('.test.'))
            
            const labels = []
            if (hasDocChanges) labels.push('documentation')
            if (hasTestChanges) labels.push('tests')
            
            if (labels.length > 0) {
              await github.rest.issues.addLabels({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: context.issue.number,
                labels: labels
              })
            }
```

---

## 6.7 Deployment Pipeline

### Multi-Stage Deployment

```yaml
name: Deploy Pipeline

on:
  push:
    branches: [ main, staging, develop ]

env:
  REGISTRY: ghcr.io

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
    
    steps:
      - uses: actions/checkout@v3
      - uses: docker/setup-buildx-action@v2
      - uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ env.REGISTRY }}/${{ github.repository }}:${{ github.sha }}

  deploy-to-staging:
    needs: build
    if: github.ref == 'refs/heads/staging'
    runs-on: ubuntu-latest
    environment: staging
    
    steps:
      - name: Deploy to staging
        run: |
          echo "Deploying ${{ needs.build.outputs.image-tag }} to staging"
          # Your staging deployment commands

  deploy-to-production:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: 
      name: production
      url: https://myapp.com
    
    steps:
      - name: Deploy to production
        run: |
          echo "Deploying ${{ needs.build.outputs.image-tag }} to production"
          # Your production deployment commands
      
      - name: Health check
        run: |
          sleep 30
          curl -f https://myapp.com/health || exit 1
      
      - name: Notify deployment
        if: success()
        uses: slackapi/slack-github-action@v1.24.0
        with:
          webhook-url: ${{ secrets.SLACK_WEBHOOK }}
          payload: |
            {
              "text": "✅ Successfully deployed to production"
            }
```

---

## 6.8 Code Quality and Security

### Comprehensive Code Quality Checks

```yaml
name: Code Quality

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  quality:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: npm
      
      - run: npm ci
      
      # Linting
      - name: Run ESLint
        run: npm run lint --format json > eslint-report.json || true
      
      # Code coverage
      - name: Test with coverage
        run: npm run test:coverage
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
          fail_ci_if_error: true
      
      # SAST - Static Analysis
      - name: Run SonarQube scan
        uses: SonarSource/sonarcloud-github-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
      
      # Dependency check
      - name: Check for vulnerable dependencies
        run: npm audit --production --audit-level=moderate || true
      
      # Security scanning
      - name: Run security scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
```

---

## 6.9 Adaptating Examples to Your Project

### Step-by-Step Guide

1. **Identify your tech stack**
   - Language (Node.js, Python, Java, Go, etc.)
   - Framework (React, Django, Spring, etc.)
   - Deployment target (Docker, AWS, Heroku, etc.)

2. **Find similar example**
   - Look at similar projects' workflows
   - Check GitHub Marketplace
   - Search GitHub workflows

3. **Copy and customize**
   - Copy relevant workflow
   - Replace tool names with yours
   - Update branch names
   - Update script commands

4. **Test incrementally**
   - Start with single job
   - Add complexity gradually
   - Verify each step before moving on

---

## Practice Exercise

Choose one example and adapt it to your project:

### For Node.js projects:
```yaml
# Use: 6.1 Node.js - Test and Build
# Customize:
# - Update branch names
# - Update scripts in package.json
# - Update node versions to test on
```

### For Python projects:
```yaml
# Use: 6.2 Python - Test and Deploy
# Customize:
# - Update Python versions
# - Update requirements files
# - Update package name for deployment
```

### For Docker projects:
```yaml
# Use: 6.3 Docker - Build and Push
# Customize:
# - Update image registry
# - Update Dockerfile path if needed
# - Configure credentials for your registry
```

---

## Common Mistakes to Avoid

❌ **Mistake 1:** Running all tests on every Windows/Mac runner
```yaml
# SLOW
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    node: [16, 18, 20]
```

✅ **Better:**
```yaml
# Test on one OS, use conditional for platform-specific
runs-on: ubuntu-latest
strategy:
  matrix:
    node: [16, 18, 20]
```

❌ **Mistake 2:** Not caching dependencies
```yaml
- run: npm install        # Downloads every time!
```

✅ **Better:**
```yaml
- uses: actions/setup-node@v3
  with:
    cache: npm            # Automatic caching!
```

❌ **Mistake 3:** Storing secrets as plain text

✅ **Better:**
```yaml
with:
  api_key: ${{ secrets.API_KEY }}
```

---

## Key Takeaways 🎯

✅ Adapt existing examples to your project
✅ Use matrix strategy for multiple configurations
✅ Cache dependencies to speed up workflows
✅ Separate building from testing from deployment
✅ Use environments for different deployment stages
✅ Add health checks and notifications
✅ Implement code quality checks

---

## Next Step
👉 **Go to Lesson 7: Best Practices** to optimize your workflows
