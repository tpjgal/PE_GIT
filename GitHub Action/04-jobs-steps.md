# Lesson 4: Jobs & Steps

## What You'll Learn
- Job execution (parallel vs sequential)
- Controlling job execution order
- Job configuration options
- Step structure and types
- Conditional execution
- Matrix builds

---

## 4.1 Jobs Basics

### Parallel Execution (Default)

By default, jobs run in parallel:

```yaml
jobs:
  job_one:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Job 1 running"
      - run: sleep 10

  job_two:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Job 2 running"
```

**Result:** Both start at same time (take ~10 seconds total, not 20)

---

## 4.2 Sequential Execution

### Using `needs`

Make jobs run one after another:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building..."

  test:
    runs-on: ubuntu-latest
    needs: build              # Run after 'build' job
    steps:
      - run: echo "Testing..."

  deploy:
    runs-on: ubuntu-latest
    needs: test               # Run after 'test' job
    steps:
      - run: echo "Deploying..."
```

**Execution order:** build → test → deploy

### Multiple Dependencies

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    steps:
      - run: npm test

  build:
    runs-on: ubuntu-latest
    needs: [lint, test]       # Both must complete first
    steps:
      - run: npm run build
```

**Execution:** lint & test (parallel) → build (after both done)

---

## 4.3 Job Configuration

### Basic Job Structure

```yaml
jobs:
  my_job:
    name: Display Name           # Shown in UI (optional)
    runs-on: ubuntu-latest       # Required
    timeout-minutes: 30          # Max runtime (default: 360)
    concurrency:                 # Cancel previous runs
      group: ci-${{ github.ref }}
      cancel-in-progress: true
    strategy:                    # Matrix/parallel strategy
      matrix:
        node-version: [16, 18, 20]
    environment: production      # Environment settings
    permissions:                 # Required permissions
      contents: read
      pull-requests: write
    outputs:                     # Share data with other jobs
      result: ${{ steps.step1.outputs.value }}
    steps: []
```

---

## 4.4 Job Conditions

### Conditional Job Execution

```yaml
jobs:
  always:
    runs-on: ubuntu-latest
    if: always()                 # Always run
    steps:
      - run: echo "This always runs"

  on_failure:
    runs-on: ubuntu-latest
    if: failure()                # Only if previous job failed
    steps:
      - run: echo "Previous job failed"

  on_success:
    runs-on: ubuntu-latest
    if: success()                # Only if previous job succeeded
    steps:
      - run: echo "Previous job succeeded"

  on_branch:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'    # Only on main
    steps:
      - run: echo "On main branch"

  on_event:
    runs-on: ubuntu-latest
    if: github.event_name == 'push'        # Only on push
    steps:
      - run: echo "On push event"
```

### Complex Conditions

```yaml
if: github.ref == 'refs/heads/main' && github.event_name == 'push'

if: contains(github.event.head_commit.message, 'deploy')

if: startsWith(github.ref, 'refs/tags/v')

if: github.event.pull_request.draft == false

if: github.repository_owner == 'myname'
```

---

## 4.5 Matrix Builds

Run job with multiple configurations:

### Basic Matrix

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16, 18, 20]
    steps:
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm test
```

**Result:** 3 jobs created (one for each Node version)

### Multi-Dimension Matrix

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    node-version: [16, 18, 20]
    include:
      - os: ubuntu-latest
        node-version: 20
        experimental: true
```

**Result:** 3×3=9 combinations (plus 1 extra with `include`)

### Include and Exclude

```yaml
strategy:
  matrix:
    node-version: [16, 18, 20]
    os: [ubuntu-latest, windows-latest]
  include:
    - node-version: 16
      deprecated: true
  exclude:
    - node-version: 16
      os: windows-latest    # Don't test node 16 on Windows
```

### Using Matrix Variables

```yaml
steps:
  - name: Run on ${{ matrix.os }}
    run: echo "Testing Node ${{ matrix.node-version }} on ${{ matrix.os }}"

  - name: Access specific value
    if: matrix.os == 'ubuntu-latest'
    run: echo "Ubuntu specific step"

  - name: Check all keys
    run: |
      echo "Keys: ${{ join(matrix.*, ',') }}"
```

---

## 4.6 Steps Basics

### Step Types

**Type 1: Using an Action**
```yaml
- name: Checkout code
  uses: actions/checkout@v3
```

**Type 2: Running a Shell Command**
```yaml
- name: Install dependencies
  run: npm install
```

**Type 3: Running Python Script**
```yaml
- name: Run Python script
  run: python script.py
  shell: python
```

### Step Structure

```yaml
- name: Step name                  # Display name (optional)
  id: my_step                      # ID for later reference (optional)
  uses: action-name@version        # OR
  run: command                      # One required
  shell: bash                       # Shell type (bash, pwsh, sh, etc.)
  working-directory: ./src          # Change directory
  env:                              # Step-level env vars
    MY_VAR: value
  with:                             # Action inputs
    key: value
  if: success()                     # Conditional execution
  timeout-minutes: 10               # Step timeout
  continue-on-error: true           # Don't fail if this fails
```

---

## 4.7 Step Execution

### Sequential Execution (Default)

Steps in a job run sequentially:

```yaml
steps:
  - run: echo "Step 1"        # Runs first
  - run: echo "Step 2"        # Waits for step 1
  - run: echo "Step 3"        # Waits for step 2
```

**If Step 2 fails:** Step 3 doesn't run (unless `continue-on-error: true`)

### Conditional Steps

```yaml
steps:
  - name: Test on push
    if: github.event_name == 'push'
    run: npm test

  - name: Deploy on main
    if: github.ref == 'refs/heads/main'
    run: npm run deploy

  - name: Notify on failure
    if: failure()             # Run if any previous step failed
    run: echo "Build failed!"

  - name: Always cleanup
    if: always()              # Run regardless of status
    run: npm run cleanup
```

### Conditional Commands

```yaml
- name: Deploy conditionally
  run: |
    if [ "${{ github.ref }}" = "refs/heads/main" ]; then
      npm run deploy:prod
    else
      npm run deploy:staging
    fi
```

---

## 4.8 Sharing Data Between Steps

### Output Variables

```yaml
steps:
  - name: Generate version
    id: version
    run: |
      VERSION="1.0.0"
      echo "version=$VERSION" >> $GITHUB_OUTPUT

  - name: Use version
    run: echo "Version is ${{ steps.version.outputs.version }}"
```

### Environment Variables

```yaml
env:
  GLOBAL_VAR: value           # Available to all steps

jobs:
  build:
    env:
      JOB_VAR: value          # Job-level env
    steps:
      - env:                  # Step-level env
          STEP_VAR: value
        run: |
          echo "Global: $GLOBAL_VAR"
          echo "Job: $JOB_VAR"
          echo "Step: $STEP_VAR"
```

### Artifacts (Sharing Between Jobs)

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: mkdir artifacts
      - run: echo "data" > artifacts/result.txt
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: build-artifacts
          path: artifacts/

  report:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Download artifact
        uses: actions/download-artifact@v3
        with:
          name: build-artifacts
      - run: cat result.txt
```

---

## 4.9 Error Handling

### Step Failures

```yaml
# Default: stop if step fails
- name: Test
  run: npm test

# Continue even if fails
- name: Optional check
  run: npm run lint:strict
  continue-on-error: true

# Don't fail the workflow for this step
- name: Experimental feature
  run: npm run experimental
  continue-on-error: true
```

### Status Checks

```yaml
- name: Check previous status
  if: failure()               # Previous step failed
  run: echo "Previous step failed"

- name: Check all previous
  if: failure()               # Any step before this failed
  run: echo "Something failed"

- name: Always notify
  if: always()                # Runs regardless
  run: echo "Workflow status: ${{ job.status }}"
```

### Error Context

```yaml
steps:
  - run: npm test
    id: test

  - name: Check test results
    if: steps.test.conclusion == 'failure'
    run: echo "Tests failed!"
```

---

## 4.10 Real-World Examples

### Example 1: Build and Test Pipeline

```yaml
name: Build Pipeline

on: push

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    needs: lint              # After lint
    strategy:
      matrix:
        node: [16, 18, 20]
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node }}
      - run: npm ci
      - run: npm test

  build:
    runs-on: ubuntu-latest
    needs: test              # After all tests
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v3
        with:
          name: dist
          path: dist/

  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v3
        with:
          name: dist
      - run: npm run deploy
```

### Example 2: Matrix Testing

```yaml
name: Matrix Tests

on: pull_request

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest]
        python: ['3.8', '3.9', '3.10', '3.11']
      fail-fast: false         # Don't cancel other jobs if one fails
    
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python }}
      - run: pip install -r requirements.txt
      - run: pytest
```

### Example 3: Conditional Deployment

```yaml
name: Deploy

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm run build

  deploy-staging:
    needs: build
    if: github.ref != 'refs/heads/main'      # Not main
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to staging..."

  deploy-prod:
    needs: build
    if: github.ref == 'refs/heads/main'      # Main only
    runs-on: ubuntu-latest
    environment: production                  # Require approval
    steps:
      - run: echo "Deploying to production..."
```

---

## Practice Exercise 1: Sequential Jobs

Create `.github/workflows/sequential.yml`:

```yaml
name: Sequential Jobs

on: push

jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Setting up..."

  build:
    needs: setup
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building..."

  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Testing..."

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying..."
```

---

## Practice Exercise 2: Matrix Build

Create `.github/workflows/matrix.yml`:

```yaml
name: Matrix Build

on: push

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest]
        node: [16, 18, 20]
    
    steps:
      - run: echo "Testing on ${{ matrix.os }} with Node ${{ matrix.node }}"
      - run: node --version
```

---

## Key Takeaways 🎯

✅ Jobs run in parallel by default
✅ Use `needs:` to make jobs sequential
✅ Use `strategy.matrix` for multiple configurations
✅ Steps run sequentially in a job
✅ Use `if:` for conditional execution
✅ Use `${{ job.status }}` and `failure()` for error handling
✅ Share data with artifacts or outputs

---

## Next Step
👉 **Go to Lesson 5: Actions & Marketplace** to learn about reusable components
