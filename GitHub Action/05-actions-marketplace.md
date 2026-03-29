# Lesson 5: Actions & Marketplace

## What You'll Learn
- What actions are
- Official GitHub actions
- Community actions from marketplace
- How to use actions
- Creating custom actions (overview)
- Action versioning

---

## 5.1 What Are Actions?

**Actions** are reusable units of code that solve common problems in workflows.

### Benefits of Actions

- ✅ Code reuse (don't repeat common tasks)
- ✅ Community-tested and maintained
- ✅ Easy integration with simple `uses:` syntax
- ✅ Standardized approach to problems
- ✅ Reduced workflow complexity

### Action Categories

1. **JavaScript Actions** - Run directly
2. **Docker Actions** - Run in container
3. **Composite Actions** - Combine multiple actions/commands
4. **Custom Actions** - Create your own

---

## 5.2 Using Actions: Basic Syntax

### Simple Action

```yaml
- uses: actions/checkout@v3
```

### Action with Inputs

```yaml
- uses: actions/setup-node@v3
  with:
    node-version: 18
    cache: npm
```

### Action with Multiple Inputs

```yaml
- uses: some-action/my-action@v1
  with:
    input1: value1
    input2: value2
    multi-line: |
      Line 1
      Line 2
```

### Retrieving Action Outputs

```yaml
- name: Build
  id: build
  uses: some-action/build@v1

- name: Use output
  run: echo "Build ID: ${{ steps.build.outputs.id }}"
```

---

## 5.3 Official GitHub Actions

These are maintained by GitHub and solve common problems:

### 1. `actions/checkout` - Get repository code

```yaml
# Basic usage
- uses: actions/checkout@v3

# With options
- uses: actions/checkout@v3
  with:
    fetch-depth: 0                    # Full history
    ref: main                         # Specific branch
    token: ${{ secrets.GITHUB_TOKEN }}
    path: subdir                      # Checkout to subdirectory
```

**When to use:** First step in almost every workflow

**Available outputs:**
```yaml
- uses: actions/checkout@v3
  id: checkout

- run: |
    echo "Commit: ${{ steps.checkout.outputs.commit }}"
```

### 2. `actions/setup-node` - Set up Node.js

```yaml
# Simple usage
- uses: actions/setup-node@v3
  with:
    node-version: 18

# Specific version
- uses: actions/setup-node@v3
  with:
    node-version: '18.12.0'

# With caching
- uses: actions/setup-node@v3
  with:
    node-version: 18
    cache: npm              # or: pnpm, yarn

# Multiple versions (in matrix)
- uses: actions/setup-node@v3
  with:
    node-version: ${{ matrix.node-version }}
```

### 3. `actions/setup-python` - Set up Python

```yaml
- uses: actions/setup-python@v4
  with:
    python-version: '3.11'

# With caching
- uses: actions/setup-python@v4
  with:
    python-version: 3.11
    cache: pip
```

### 4. `actions/setup-java` - Set up Java

```yaml
- uses: actions/setup-java@v3
  with:
    java-version: '17'
    distribution: 'temurin'
```

### 5. `actions/upload-artifact` - Store files

```yaml
- uses: actions/upload-artifact@v3
  with:
    name: build-output          # Artifact name
    path: dist/                 # Files to upload
    retention-days: 5           # How long to keep

# Multiple files
- uses: actions/upload-artifact@v3
  with:
    name: reports
    path: |
      test-results/**/*.xml
      coverage/**/*.html
```

### 6. `actions/download-artifact` - Retrieve files

```yaml
# All artifacts
- uses: actions/download-artifact@v3

# Specific artifact
- uses: actions/download-artifact@v3
  with:
    name: build-output
    path: ./local-dir
```

### 7. `actions/cache` - Cache dependencies

```yaml
# Manual caching
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-

# Or use setup actions' built-in cache
- uses: actions/setup-node@v3
  with:
    node-version: 18
    cache: npm              # Simplified!
```

### 8. `actions/github-script` - Run JavaScript

```yaml
- uses: actions/github-script@v6
  with:
    script: |
      console.log('Repository:', context.repo.repo)
      console.log('Ref:', context.ref)
      
      const issues = await github.rest.issues.listForRepo({
        owner: context.repo.owner,
        repo: context.repo.repo
      })
      console.log('Open issues:', issues.data.length)
```

---

## 5.4 Community Actions (GitHub Marketplace)

Find actions at: https://github.com/marketplace?type=actions

### Popular Examples

#### Test/Coverage Actions
```yaml
# Test reporting
- uses: EnricoMi/publish-unit-test-result-action@v2
  if: always()
  with:
    files: results/**/*.xml

# Code coverage
- uses: codecov/codecov-action@v3
  with:
    files: ./coverage.xml
    verbose: true
```

#### Deployment Actions
```yaml
# Deploy to AWS
- uses: aws-actions/configure-aws-credentials@v1

# Deploy to Azure
- uses: azure/setup-helm@v3

# Deploy to Heroku
- uses: akhileshns/heroku-deploy@v3.12.12
  with:
    heroku_api_key: ${{ secrets.HEROKU_API_KEY }}
    heroku_app_name: "my-app"
    heroku_email: ${{ secrets.HEROKU_EMAIL }}
```

#### Notification Actions
```yaml
# Slack notification
- uses: slackapi/slack-github-action@v1.24.0
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "Build completed: ${{ job.status }}"
      }

# Email notification
- uses: davisnathaniel/action-send-email@v1
  with:
    server_address: ${{ secrets.EMAIL_SERVER }}
    username: ${{ secrets.EMAIL_USERNAME }}
    password: ${{ secrets.EMAIL_PASSWORD }}
    subject: Build Status
    to: me@example.com
    from: ci@example.com
```

#### Code Quality Actions
```yaml
# Linting
- uses: super-linter/super-linter@v4.10.0
  env:
    DEFAULT_BRANCH: main
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

# Security scanning
- uses: github/super-linter@v4
```

---

## 5.5 Using Marketplace Actions

### Finding Actions

1. Go to https://github.com/marketplace?type=actions
2. Search for action (e.g., "deploy", "test")
3. Read documentation
4. Get exact syntax

### Action Structure

```
owner/action-name@version

Examples:
- actions/checkout@v3                     # Official
- codecov/codecov-action@v3              # Community
- my-org/my-custom-action@v1             # Your action
```

### Versioning

```yaml
uses: author/action@v1              # Major version (recommended)
uses: author/action@v1.2.3          # Specific version
uses: author/action@main            # Branch
uses: author/action@abc123          # Commit SHA
uses: ./local/path/to/action        # Local action
```

**Best practice:** Use major version for stability
```yaml
uses: actions/checkout@v3           # Gets latest v3.x.x
```

---

## 5.6 Action Inputs and Outputs

### Understanding Documentation

Each action documents its inputs and outputs:

```yaml
# Example from codecov/codecov-action

inputs:
  - name: files
    description: Path to coverage files
    required: false
  
  - name: flags
    description: Flags to mark coverage
    required: false

outputs:
  - name: coverage
    description: Coverage percentage
```

### Using Inputs

```yaml
- uses: codecov/codecov-action@v3
  with:
    files: ./coverage.xml
    flags: unittests
    verbose: true
```

### Using Outputs

```yaml
- id: deploy
  uses: aws-actions/deploy-cloudformation-stack@v1
  with:
    name: my-stack

- run: echo "Stack ID: ${{ steps.deploy.outputs.stack-id }}"
```

---

## 5.7 Action Best Practices

### ✅ Do's

```yaml
# 1. Use explicit versions
uses: actions/checkout@v3           # GOOD
uses: actions/checkout@latest       # BAD

# 2. Check action security
# Review source on github.com before using

# 3. Cache when possible
- uses: actions/setup-node@v3
  with:
    cache: npm              # Enable caching

# 4. Use official actions when available
uses: actions/checkout@v3           # Official
uses: some-random/checkout@v1       # Question this!

# 5. Document why you're using an action
- name: Code coverage
  # Using to generate coverage reports
  uses: codecov/codecov-action@v3
```

### ❌ Don'ts

```yaml
# 1. Don't use @latest in production
uses: actions/checkout@latest       # ??? Could break!

# 2. Don't pin to commits without reason
uses: owner/action@abc123def456     # Hard to track

# 3. Don't chain too many actions
# Each action adds overhead
- uses: action1@v1
- uses: action2@v1
- uses: action3@v1
- uses: action4@v1
- uses: action5@v1

# 4. Don't store credentials as plain text
with:
  api_key: "sk-1234567890"          # WRONG!

# Use secrets instead
with:
  api_key: ${{ secrets.API_KEY }}   # RIGHT!
```

---

## 5.8 Creating Custom Actions (Overview)

You can create your own reusable actions:

### Simple Composite Action

Create `.github/actions/my-action/action.yml`:

```yaml
name: My Custom Action
description: Does something useful

inputs:
  file-path:
    description: Path to process
    required: true

outputs:
  result:
    description: Processing result
    value: ${{ steps.process.outputs.result }}

runs:
  using: composite
  steps:
    - name: Process file
      id: process
      shell: bash
      run: |
        echo "Processing: ${{ inputs.file-path }}"
        result=$(wc -l < ${{ inputs.file-path }})
        echo "result=$result" >> $GITHUB_OUTPUT
```

### Using Your Custom Action

```yaml
- uses: ./.github/actions/my-action
  with:
    file-path: README.md

- run: echo "Result: ${{ steps.my-action.outputs.result }}"
```

---

## 5.9 Real-World Action Example

### Complete Workflow Using Multiple Actions

```yaml
name: Complete CI/CD

on: push

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      # 1. Get code
      - uses: actions/checkout@v3
      
      # 2. Set up Node
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: npm
      
      # 3. Install and build
      - run: npm ci
      - run: npm run build
      
      # 4. Run tests
      - run: npm test
      
      # 5. Upload coverage
      - uses: codecov/codecov-action@v3
        with:
          files: ./coverage.xml
      
      # 6. Store artifacts
      - uses: actions/upload-artifact@v3
        with:
          name: build
          path: dist/
      
      # 7. Notify
      - uses: slackapi/slack-github-action@v1.24.0
        if: always()
        with:
          webhook-url: ${{ secrets.SLACK_WEBHOOK }}
          payload: |
            {
              "text": "Build: ${{ job.status }}"
            }
```

---

## Practice Exercise 1: Use Multiple Official Actions

Create `.github/workflows/practice-actions.yml`:

```yaml
name: Practice with Actions

on: push

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: npm
      
      - run: npm ci
      - run: npm test
      
      - uses: actions/upload-artifact@v3
        if: always()
        with:
          name: test-results
          path: coverage/
```

---

## Practice Exercise 2: Find and Use Marketplace Action

1. Go to https://github.com/marketplace?type=actions
2. Find an action relevant to your project
3. Read its documentation
4. Add it to your workflow
5. Test it

Example: If you use Python, find and use a code formatting action.

---

## Quiz

1. **What's the recommended way to specify action versions?**
   - Major version (e.g., `@v3`)

2. **Where do you store sensitive data for actions?**
   - In repository secrets, accessed via `${{ secrets.SECRET_NAME }}`

3. **What's the first action you should use in most workflows?**
   - `actions/checkout@v3`

---

## Key Takeaways 🎯

✅ Actions are reusable code components
✅ Official GitHub actions solve common problems
✅ GitHub Marketplace has community actions
✅ Use major versions for stability
✅ Always use `${{ secrets.* }}` for sensitive data
✅ Cache dependencies when possible
✅ You can create custom composite actions

---

## Next Step
👉 **Go to Lesson 6: Practical Examples** to see real-world workflows
