# Lesson 1: Core Concepts

## What You'll Learn
- What GitHub Actions is and why you need it
- The difference between event-driven and scheduled automation
- Major components of GitHub Actions
- How GitHub Actions fits in your development workflow

---

## 1.1 The Problem GitHub Actions Solves

**Before GitHub Actions:**
- Need separate CI/CD tool (Jenkins, Travis CI, CircleCI)
- Complex integration with GitHub
- Extra service to maintain and configure
- Additional costs

**With GitHub Actions:**
- Built into GitHub itself
- Simple YAML configuration
- Free tier for public repos
- No external integrations needed

**Real-world scenario:**
```
Developer pushes code → GitHub detects push → 
Automatically runs tests → Reports results → 
(Optional) Deploy application
↵ All without manual intervention!
```

---

## 1.2 The Four Pillars of GitHub Actions

### 1. **Workflows**
- Automated processes stored in `.github/workflows/` directory
- Written in YAML format
- Triggered by events or schedules
- **Example:** "Run tests whenever code is pushed"

### 2. **Triggers (Events)**
- What starts a workflow
- Can be repository events (push, pull request, release)
- Can be scheduled (cron jobs)
- Can be external webhooks
- **Examples:**
  - `push` - when code is pushed
  - `pull_request` - when PR is created/updated
  - `schedule` - at specific times
  - `workflow_dispatch` - manual trigger

### 3. **Jobs**
- Unit of work in a workflow
- Run in parallel by default (unless configured otherwise)
- Each job runs on its own runner/machine
- **Example:** One job to test, another to build

### 4. **Actions**
- Reusable units of code
- Can be custom or from marketplace
- Simplify common tasks
- **Examples:**
  - `actions/checkout@v3` - check out repository code
  - `actions/setup-node@v3` - set up Node.js environment
  - Other published actions for specific tools

---

## 1.3 The Execution Model

```
TRIGGER (Event/Schedule)
         ↓
    START WORKFLOW
         ↓
  CREATE RUNNER (machine)
         ↓
   RUN ALL JOBS
   (in parallel or sequence)
         ↓
    EACH JOB:
    - Runs steps sequentially
    - Each step runs in same environment
    - Can use actions or shell commands
         ↓
   PUBLISH RESULTS
   (success/failure)
         ↓
   (Optional) Send notifications
```

---

## 1.4 Key Concepts Explained

### Runners
**What:** Virtual machine or container where your workflow runs
**Types:**
- **GitHub-hosted** (free, includes Ubuntu, Windows, macOS)
- **Self-hosted** (your own server, for private/demanding tasks)

### Artifacts
**What:** Files generated during workflow execution
**Uses:**
- Share data between jobs
- Store test results, logs
- Download after workflow completes

### Secrets
**What:** Encrypted variables for sensitive data
**Use for:**
- API keys, tokens, credentials
- Database passwords
- Deployment keys

### Matrix Builds
**What:** Run same job with different configurations
**Example:**
```
Test on Python: 3.8, 3.9, 3.10, 3.11
Each combination runs as separate job
```

---

## 1.5 When to Use GitHub Actions

✅ **Good Use Cases:**
- Running tests on every commit
- Building deployable artifacts
- Running code quality checks
- Automated deployments
- Release automation
- Document generation
- Scheduled maintenance tasks

❌ **Poor Use Cases:**
- Long-running jobs (24+ hours)
- Extremely resource-intensive tasks
- Real-time continuous processes
- (Consider self-hosted runners for these)

---

## 1.6 GitHub Actions vs Other CI/CD Tools

| Feature | GitHub Actions | Jenkins | CircleCI | Travis |
|---------|---|---|---|---|
| Learn Effort | Low | High | Medium | Medium |
| Setup Time | Minutes | Hours | Hours | Minutes |
| GitHub Integration | Native | Plugin | Good | Good |
| Free for Public | Yes | Yes | Yes | Yes |
| Cost for Private | Included* | Free (self) | Paid | Paid |

*Generous free allowance for private repos

---

## 1.7 Common Misconceptions

### ❌ Misconception 1: "GitHub Actions is only for testing"
✅ **Truth:** It can build, test, deploy, publish, notify, generate docs, and much more!

### ❌ Misconception 2: "I need a separate server to run workflows"
✅ **Truth:** GitHub-hosted runners included for free (public repos & included allowance for private)

### ❌ Misconception 3: "YAML syntax is too complicated"
✅ **Truth:** Basic YAML is very simple - just indentation and key-value pairs

### ❌ Misconception 4: "GitHub Actions is slow"
✅ **Truth:** Jobs start in seconds and run fast - GitHub uses powerful hardware

---

## 1.8 Action Plan

To get started, you need:

1. ✅ A GitHub repository (can be existing or new)
2. ✅ Basic understanding of YAML (we'll cover syntax next)
3. ✅ An idea of what you want to automate
4. ✅ 5-10 minutes to create your first workflow

---

## Quiz: Test Your Knowledge

1. **What triggers a workflow to run?**
   - A) Only manual push
   - B) Events, schedules, or manual trigger
   - C) Only pull requests

2. **Where are workflows stored?**
   - A) `.git/workflows/`
   - B) `.github/workflows/`
   - C) `/workflows/` at repo root

3. **What is a runner?**
   - A) A person who runs tests
   - B) A machine where your workflow executes
   - C) A command that starts workflows

4. **Are GitHub Actions free for public repositories?**
   - A) Yes, completely free
   - B) No, always paid
   - C) Only with GitHub Pro

**Answers:** 1-B, 2-B, 3-B, 4-A ✅

---

## Key Takeaways 🎯

✅ GitHub Actions automates tasks triggered by events or schedules
✅ Workflow = automated process in `.github/workflows/`
✅ Runners = machines that execute your workflows
✅ Jobs execute in parallel, steps execute sequentially
✅ It's built-in to GitHub and free for public repos
✅ YAML syntax is simple

---

## Next Step
👉 **Go to Lesson 2: Workflow Anatomy** to learn how to structure a workflow file
