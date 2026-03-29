# Lesson 2: Workflow Anatomy

## What You'll Learn
- YAML syntax basics
- Complete structure of a workflow file
- What each section does
- How to read and write workflow files

---

## 2.1 YAML Basics (5-minute crash course)

**YAML** is a human-friendly data format. Here are the essentials:

### Key-Value Pairs
```yaml
name: My Workflow
on: push
```
- `name:` is the key, `My Workflow` is the value
- No quotes needed for simple values

### Lists (Arrays)
```yaml
# Using dashes
events:
  - push
  - pull_request
  - schedule

# Or inline
events: [push, pull_request, schedule]
```

### Nested Objects
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
```

### Indentation is CRITICAL!
- Use **2 spaces** (not tabs!)
- Indentation shows hierarchy
- Wrong indentation = parse error

### Strings with Special Characters
```yaml
# Plain string
script: echo hello

# Quoted for strings with colons or special chars
script: "echo 'hello: world'"

# Multi-line string
script: |
  echo "Line 1"
  echo "Line 2"
```

---

## 2.2 Workflow File Anatomy

### File Location & Naming
```
your-repository/
└── .github/
    └── workflows/
        └── ci.yml          ← Workflow file
```

**Rules:**
- Must be in `.github/workflows/` directory
- File extension: `.yml` or `.yaml`
- Can have multiple workflow files

### Complete Workflow Structure

```yaml
# 1. WORKFLOW METADATA
name: CI Pipeline                    # Display name in GitHub UI

# 2. TRIGGERS
on:                                   # When this workflow runs
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

# 3. ENVIRONMENT VARIABLES (optional)
env:
  REGISTRY: ghcr.io

# 4. JOBS
jobs:
  build:                              # Job name (you choose this)
    runs-on: ubuntu-latest            # Runner type
    
    # 5. JOB-LEVEL ENVIRONMENT VARIABLES (optional)
    env:
      NODE_ENV: production
    
    # 6. STEPS
    steps:
      - name: Checkout code           # Step name
        uses: actions/checkout@v3     # Use an action
      
      - name: Print message
        run: echo "Hello World"        # Run a shell command
```

---

## 2.3 Detailed Breakdown

### 1. Metadata Section

```yaml
name: CI Pipeline
description: Runs tests and builds application
```

| Field | Required? | Purpose |
|-------|-----------|---------|
| `name` | Yes | Display name in Actions tab |
| `description` | No | Description shown in Actions |

### 2. Triggers (`on:`)

```yaml
on: push                    # Simple: any push

on:                         # Multiple events
  push:
  pull_request:

on:                         # With options
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
```

### 3. Environment Variables (Workflow-level)

```yaml
env:
  NODE_VERSION: 18
  ENVIRONMENT: production
```

- Available to all jobs
- Can be overridden at job or step level
- Use as: `${{ env.NODE_VERSION }}`

### 4. Jobs Section

```yaml
jobs:
  job_name_1:               # First job (parallel)
    runs-on: ubuntu-latest
    steps: [...]
  
  job_name_2:               # Second job (parallel by default)
    runs-on: windows-latest
    steps: [...]
    needs: job_name_1       # Make sequential: run after job_name_1
```

### 5. Job Configuration

```yaml
build:                                    # Your job name
  runs-on: ubuntu-latest                  # See complete list below
  timeout-minutes: 30                     # Max runtime
  concurrency:                            # Prevent parallel runs
    group: build-${{ github.ref }}
    cancel-in-progress: true
  
  strategy:                               # Matrix build
    matrix:
      node-version: [16, 18, 20]
      os: [ubuntu-latest, windows-latest]
  
  environment: production                 # Environment protection
  
  permissions:                            # Required permissions
    contents: read
    pull-requests: write
```

### 6. Steps

```yaml
steps:
  # TYPE 1: Using an Action
  - name: Checkout code
    uses: actions/checkout@v3
    with:                               # Action inputs
      fetch-depth: 0
  
  # TYPE 2: Running a Command
  - name: Run tests
    run: npm test
    shell: bash                         # Shell type
    working-directory: ./src            # Change directory
  
  # TYPE 3: Conditional Execution
  - name: Deploy
    if: github.ref == 'refs/heads/main'
    run: npm run deploy
  
  # TYPE 4: Using Variables
  - name: Use variable
    run: echo ${{ env.NODE_VERSION }}
```

---

## 2.4 Available Runners

### GitHub-Hosted Runners

```yaml
runs-on: ubuntu-latest          # Ubuntu 22.04 or 20.04
runs-on: windows-latest         # Windows Server 2022
runs-on: macos-latest           # macOS Ventura
runs-on: macos-latest-large     # macOS (more powerful)

# Specific versions
runs-on: ubuntu-22.04
runs-on: windows-2019
```

### Self-Hosted Runners
```yaml
runs-on: self-hosted
runs-on: [self-hosted, linux, x64]
```

---

## 2.5 Variables and Contexts

### Using Variables

```yaml
steps:
  - name: Print info
    run: |
      echo "Repository: ${{ github.repository }}"
      echo "Branch: ${{ github.ref }}"
      echo "Event: ${{ github.event_name }}"
      echo "Node version: ${{ env.NODE_VERSION }}"
```

### Common Contexts

```yaml
${{ github.repository }}      # owner/repo
${{ github.ref }}             # Branch or tag
${{ github.event_name }}      # Event that triggered
${{ github.actor }}           # User who triggered
${{ github.sha }}             # Commit SHA
${{ github.workspace }}       # Working directory
${{ runner.os }}              # ubuntu, windows, macos
```

---

## 2.6 Your First Workflow (Step-by-Step)

### Step 1: Create the file

In your repository, create: `.github/workflows/hello.yml`

### Step 2: Add basic structure

```yaml
name: Hello World

on:
  push:
    branches: [ main ]

jobs:
  greet:
    runs-on: ubuntu-latest
    steps:
      - name: Say hello
        run: echo "Hello from GitHub Actions!"
```

### Step 3: Commit and push

```bash
git add .github/workflows/hello.yml
git commit -m "Add hello world workflow"
git push
```

### Step 4: View results

- Go to your repository
- Click "Actions" tab
- See your workflow run!

---

## 2.7 Common Syntax Mistakes

### ❌ Error 1: Wrong Indentation
```yaml
# WRONG (tabs!)
jobs:
	build:          ← This is a tab, not spaces!
    steps: []

# CORRECT (2 spaces)
jobs:
  build:
    steps: []
```

### ❌ Error 2: Missing colon
```yaml
# WRONG
on push

# CORRECT
on: push
```

### ❌ Error 3: Quotes in wrong place
```yaml
# WRONG
name: 'My Workflow'
on: 'push'

# CORRECT
name: My Workflow
on: push

# But DO quote if needed
run: 'echo "hello: world"'
```

### ❌ Error 4: Undefined variable
```yaml
# WRONG
run: echo $MY_VAR        # Not defined!

# CORRECT
run: echo ${{ env.MY_VAR }}
```

---

## 2.8 Validation Tools

**GitHub provides a built-in validator:**
- Create/edit workflow file in GitHub web editor
- It auto-validates syntax
- Shows errors immediately

**Local validation:**
```bash
# Install actionlint
brew install actionlint

# Validate your workflow
actionlint .github/workflows/*.yml
```

---

## Practice Exercise 1

**Goal:** Create a simple workflow

1. In your repository, create `.github/workflows/first.yml`
2. Add this workflow:
   ```yaml
   name: My First Workflow
   
   on: push
   
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - name: Print variables
           run: |
             echo "Repository: ${{ github.repository }}"
             echo "Branch: ${{ github.ref }}"
             echo "Commit: ${{ github.sha }}"
   ```
3. Commit and push to your repository
4. Go to Actions tab and watch it run
5. Check the output!

**Expected result:** You see a successful workflow with printed variables.

---

## Practice Exercise 2

**Challenge:** Create a workflow with multiple jobs

```yaml
name: Multi-Job Workflow

on: push

jobs:
  job1:
    runs-on: ubuntu-latest
    steps:
      - run: echo "I am job 1"
  
  job2:
    runs-on: ubuntu-latest
    steps:
      - run: echo "I am job 2"
```

**What to observe:**
- Both jobs run in parallel
- They complete independently
- Both show in Actions tab

---

## Quiz: Test Your Knowledge

1. **Where do you put workflow files?**
   - C) `.github/workflows/`

2. **YAML uses which character for indentation?**
   - A) Spaces (2 spaces per level)

3. **How do you reference an environment variable in a step?**
   - B) `${{ env.VARIABLE_NAME }}`

4. **Can you run multiple jobs in parallel?**
   - A) Yes, by default

---

## Key Takeaways 🎯

✅ Workflow files go in `.github/workflows/` as YAML
✅ YAML structure: name → on → jobs
✅ Each job has steps that run sequentially
✅ Steps can use actions (`uses:`) or run commands (`run:`)
✅ Use `${{ }}` to access variables and contexts
✅ 2-space indentation is critical!

---

## Next Step
👉 **Go to Lesson 3: Triggers & Events** to learn what starts workflows
