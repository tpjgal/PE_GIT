# Lesson 3: Triggers & Events

## What You'll Learn
- Different triggers that start workflows
- How to configure conditional triggers
- Event payload and filtering
- Scheduling workflows
- Manual triggers

---

## 3.1 Trigger Types

GitHub Actions workflows can be triggered by:

1. **Repository Events** (code changes, PRs, releases)
2. **Scheduled Events** (cron jobs)
3. **Manual Triggers** (workflow_dispatch)
4. **External Triggers** (webhooks, repositories)
5. **Workflow Triggers** (other workflows)

---

## 3.2 Repository Events (Most Common)

### `push` - When code is pushed

```yaml
# Trigger on any push to any branch
on: push

# Trigger only on specific branches
on:
  push:
    branches: [ main, develop ]

# Trigger only on specific branches (pattern)
on:
  push:
    branches:
      - main
      - release/*        # matches: release/v1, release/v2, etc.
      - feature-**       # matches: feature-X, feature-Y, etc.

# Trigger on specific paths (ignore others)
on:
  push:
    paths:
      - 'src/**'         # only if files in src/ changed
      - 'package.json'
      - '.github/workflows/**'

# Trigger except on certain paths (ignore)
on:
  push:
    branches: [ main ]
    paths-ignore:
      - 'docs/**'        # ignore doc changes
      - '*.md'           # ignore markdown files

# Specific branches to ignore
on:
  push:
    branches-ignore:
      - develop         # don't trigger on develop
      - release/*       # don't trigger on release branches
```

### `pull_request` - When PR is opened/updated

```yaml
# Trigger on any PR
on: pull_request

# Trigger on PR to specific branches
on:
  pull_request:
    branches: [ main ]

# Trigger on PR with specific actions
on:
  pull_request:
    types:
      - opened          # PR is created
      - synchronize     # new commits pushed
      - reopened        # PR reopened (default)
      - edited          # PR title/description changed

# Common pattern: require checks before merge
on:
  pull_request:
    branches: [ main, develop ]
    types: [ opened, synchronize ]
```

### `release` - When release is published

```yaml
on:
  release:
    types:
      - published       # full release published
      - created         # draft created
      - edited
      - deleted
```

### `workflow_run` - Trigger on other workflow completion

```yaml
on:
  workflow_run:
    workflows: [ "CI" ]      # Wait for "CI" workflow to complete
    types: [ completed ]     # When it's done
    branches: [ main ]
```

---

## 3.3 Scheduled Events

### `schedule` - Cron job syntax

```yaml
# Run at specific time (UTC)
on:
  schedule:
    - cron: '30 5 * * 1'    # 5:30 AM UTC every Monday

# Multiple schedules
on:
  schedule:
    - cron: '0 9 * * MON-FRI'   # Weekday at 9 AM
    - cron: '0 0 * * 0'          # Weekly at midnight Sunday

# Can also trigger manually or on push
on:
  push:
    branches: [ main ]
  schedule:
    - cron: '0 * * * *'      # Every hour
```

### Cron Syntax Reference

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of the month (1 - 31)
│ │ │ ┌───────────── month (1 - 12 or JAN-DEC)
│ │ │ │ ┌───────────── day of the week (0 - 6 or SUN-SAT)
│ │ │ │ │
│ │ │ │ │
* * * * *
```

### Cron Examples

```yaml
# Every day at midnight UTC
cron: '0 0 * * *'

# Every Monday at 9 AM UTC
cron: '0 9 * * 1'

# Every 6 hours
cron: '0 */6 * * *'

# Every 15 minutes
cron: '*/15 * * * *'

# First day of month at 3 AM
cron: '0 3 1 * *'

# Monthly (last day)
cron: '0 0 L * *'          # Not standard, use: '0 0 28-31 * *'

# Every weekday at 9:30 AM
cron: '30 9 * * 1-5'

# Never (empty schedule)
cron: ''                   # Commented out
```

### Timezone Note
- GitHub always runs scheduled workflows in **UTC**
- No timezone support yet
- Calculate UTC time from your timezone!

---

## 3.4 Manual Triggers

### `workflow_dispatch` - Manual run from UI

```yaml
on:
  workflow_dispatch

# With input parameters
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production
      
      version:
        description: 'Version to deploy'
        required: true
        type: string
```

**Using in workflow:**
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo "Deploying to: ${{ inputs.environment }}"
          echo "Version: ${{ inputs.version }}"
```

**Using from GitHub UI:**
- Go to Actions tab
- Select workflow
- Click "Run workflow"
- Fill in inputs
- Click green button

---

## 3.5 Complex Trigger Logic

### Multiple Triggers

```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  release:
    types: [ published ]
  workflow_dispatch:
```

**Behavior:** Workflow runs if ANY trigger matches

### Conditional Job Execution

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'    # Only on PRs
    steps:
      - run: npm test

  deploy:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    steps:
      - run: npm run deploy
```

### More Conditions

```yaml
if: github.event_name != 'pull_request'        # NOT a PR
if: contains(github.ref, 'refs/tags')          # Is a tag
if: startsWith(github.ref, 'refs/heads/main')  # Is main branch
if: success()                                   # Previous step succeeded
if: failure()                                   # Previous step failed
if: always()                                    # Always run regardless
```

---

## 3.6 Event Payload Information

Every trigger provides information you can use:

```yaml
on:
  push:

jobs:
  info:
    runs-on: ubuntu-latest
    steps:
      - name: Show event info
        run: |
          echo "Event: ${{ github.event_name }}"
          echo "Repo: ${{ github.repository }}"
          echo "Branch: ${{ github.ref }}"          # Full ref: refs/heads/main
          echo "Branch short: ${{ github.ref_name }}"  # Just: main
          echo "Commit: ${{ github.sha }}"
          echo "Author: ${{ github.actor }}"
          echo "Timestamp: ${{ github.event.created_at }}"
```

### Push Event Details

```yaml
on:
  push:

jobs:
  details:
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo "Commits: ${{ github.event.commits[0].message }}"
          echo "Author: ${{ github.event.commits[0].author.name }}"
          echo "Modified files: ${{ github.event.commits[0].modified }}"
```

### Pull Request Details

```yaml
on:
  pull_request:

jobs:
  pr_info:
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo "PR Title: ${{ github.event.pull_request.title }}"
          echo "PR Number: ${{ github.event.pull_request.number }}"
          echo "Author: ${{ github.event.pull_request.user.login }}"
```

---

## 3.7 Trigger Filtering Patterns

### Branch Patterns

```yaml
branches: [ main ]                    # Exact match
branches: [ main, develop ]           # Multiple exact
branches-ignore: [ develop ]          # Exclude pattern

# Patterns
branches: [ main, release/* ]         # Glob patterns
branches: [ main, 'feature/**' ]      # Matches nested
```

### Path Patterns

```yaml
# Trigger only if specific paths changed
paths:
  - 'src/**'
  - 'package.json'
  - 'package-lock.json'

# Trigger except for certain paths
paths-ignore:
  - 'docs/**'
  - '*.md'
  - 'README.md'
```

### Tag Patterns

```yaml
on:
  push:
    tags:
      - 'v*'                 # Matches: v1.0, v2.1.3, etc.
      - 'release-*'         # Matches: release-1.0, etc.
```

---

## 3.8 Real-World Examples

### Example 1: Run tests on PR

```yaml
name: PR Validation

on:
  pull_request:
    branches: [ main, develop ]
    types: [ opened, synchronize ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm install
      - run: npm test
```

### Example 2: Deploy on release

```yaml
name: Deploy Release

on:
  release:
    types: [ published ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm install
      - run: npm run build
      - name: Deploy
        run: npx surge --project ./dist --domain my-app.surge.sh
```

### Example 3: Nightly tests

```yaml
name: Nightly Tests

on:
  schedule:
    - cron: '0 2 * * *'        # 2 AM UTC every day

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm install
      - run: npm run test:e2e
```

### Example 4: Cleanup job

```yaml
name: Cleanup Old Artifacts

on:
  schedule:
    - cron: '0 */6 * * *'       # Every 6 hours
  workflow_dispatch:             # Also allow manual trigger

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo "Cleaning up old artifacts..."
          # Your cleanup script here
```

---

## Practice Exercise 1: Multiple Triggers

Create `.github/workflows/triggers.yml`:

```yaml
name: Multiple Triggers

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  log_info:
    runs-on: ubuntu-latest
    steps:
      - name: Show trigger info
        run: |
          echo "Event: ${{ github.event_name }}"
          echo "Ref: ${{ github.ref }}"
          echo "Actor: ${{ github.actor }}"
```

Test this by:
1. Making a commit to main
2. Creating a PR
3. Manually triggering from Actions tab

---

## Practice Exercise 2: Scheduled Job

Create `.github/workflows/schedule.yml`:

```yaml
name: Daily Status Check

on:
  schedule:
    - cron: '0 9 * * MON-FRI'

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Daily health check at 9 AM UTC on weekdays"
```

(You can't test scheduled workflows immediately - they run at scheduled time)

---

## Quiz

1. **What's the cron syntax for every day at midnight UTC?**
   - `0 0 * * *`

2. **How do you trigger a workflow manually from the UI?**
   - Use `workflow_dispatch`

3. **What event fires when a PR is created?**
   - `pull_request` with `types: [opened]`

---

## Key Takeaways 🎯

✅ Repository events: `push`, `pull_request`, `release`, `workflow_run`
✅ Scheduled events: `schedule` with cron syntax (UTC)
✅ Manual triggers: `workflow_dispatch`
✅ Use `branches`, `paths`, `tags` to filter triggers
✅ Use `if:` conditions to control job execution
✅ Access event info via `${{ github.event.* }}`

---

## Next Step
👉 **Go to Lesson 4: Jobs & Steps** to learn job execution and ordering
