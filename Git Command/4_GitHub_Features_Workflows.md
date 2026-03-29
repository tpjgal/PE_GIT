# GitHub Features & Real-World Workflows

## Table of Contents
1. [GitHub-Specific Features](#github-specific-features)
2. [Pull Request Workflows](#pull-request-workflows)
3. [Issues and Project Management](#issues-and-project-management)
4. [Collaborative Development](#collaborative-development)
5. [GitHub Actions & Automation](#github-actions--automation)
6. [Security & Best Practices](#security--best-practices)
7. [Real-World Project Scenarios](#real-world-project-scenarios)

---

## GitHub-Specific Features

### 1. Remote URL Operations
```bash
# View remote information
git remote -v
git remote show origin

# Change remote URL
git remote set-url origin https://github.com/newuser/project.git

# Add OAuth token for authentication (HTTPS)
git remote set-url origin https://username:token@github.com/user/repo.git

# Use SSH key instead of password
git remote set-url origin git@github.com:user/repo.git

# Verify connection
ssh -T git@github.com
```

---

### 2. GitHub Token Authentication
```bash
# Generate personal access token on GitHub
# Settings → Developer settings → Personal access tokens

# Use token in clone URL
git clone https://username:ghp_your_token@github.com/user/repo.git

# Store credentials securely
git config credential.helper store  # Linux/Mac
# Windows: uses credential manager automatically

# Later pushes automatically use stored credentials
git push
```

---

### 3. Forking and Upstream Workflow
```bash
# Fork on GitHub web interface...

# Clone YOUR fork
git clone https://github.com/yourname/project.git
cd project

# Add upstream remote (original project)
git remote add upstream https://github.com/original-owner/project.git

# Keep fork updated with upstream
git fetch upstream
git pull upstream main

# Push your updates to your fork
git push origin main
```

**Scenario - Contributing to Open Source:**
```bash
# 1. Fork the project on GitHub (web interface)

# 2. Clone your fork
git clone https://github.com/yourname/awesome-library.git
cd awesome-library

# 3. Add upstream reference
git remote add upstream https://github.com/awesome-owner/awesome-library.git

# 4. Create feature branch
git checkout -b feature/awesome-improvement

# 5. Make changes and commit
git add .
git commit -m "Add awesome new feature"

# 6. Keep updated with upstream
git fetch upstream
git rebase upstream/main

# 7. Push to your fork
git push origin feature/awesome-improvement

# 8. Open Pull Request on GitHub (from your fork → original project)
```

---

## Pull Request Workflows

### 1. Creating a Pull Request from CLI
```bash
# Using GitHub CLI (gh)
# Install: brew install gh (or choco install gh on Windows)

# Login
gh auth login

# Create PR from current branch
gh pr create --title "Fix login bug" --body "Resolves #123"

# Create draft PR
gh pr create --draft

# Merge PR from CLI
gh pr merge 42 --squash
```

---

### 2. PR Review Best Practices
```bash
# Fetch PR locally to review
gh pr checkout 42

# Or manually
git fetch origin pull/42/head:pr-42
git checkout pr-42

# Review code
# Make and test changes locally
# Push feedback

# Add commits to same PR
git add .
git commit -m "Address review feedback"
git push origin pr-42
```

---

### 3. Handling PR Feedback
```bash
# Common workflow: Reviewer requests changes

# Make the changes
git add .
git commit -m "Address review: improve error handling"

# Don't create new branch!
# Just push to same branch
git push

# PR automatically updates with new commits
# Re-request review on GitHub
```

---

## Issues and Project Management

### 1. Linking Commits to Issues
```bash
# Reference issue in commit message
git commit -m "Fix bug #123: redirect not working"

# GitHub recognizes #123 and links commit to issue

# Close issue automatically
git commit -m "Fixes #456: wrong calculation"
# When merged, Github auto-closes issue #456

# Multiple issues
git commit -m "Resolves #100 and #101"
```

**Supported close keywords:**
- `close`, `closes`, `closed`
- `fix`, `fixes`, `fixed`
- `resolve`, `resolves`, `resolved`

---

### 2. Project Boards (GitHub Projects)
```
# Manual workflow:
1. Create issue
2. Add to project board
3. Move through columns: To Do → In Progress → Done
4. Link to PR
5. Auto-close when PR merges
```

---

## Collaborative Development

### 1. Code Review Process
```bash
# Standard PR review flow:

# Developer:
# 1. Create feature branch and PR
# 2. Await review

# Reviewer:
# 1. Check out PR locally (gh pr checkout #123)
# 2. Review code
# 3. Request changes or approve

# Developer (feedback received):
# 1. Make requested changes
# 2. Commit and push
# 3. Re-request review
# 4. Wait for approval

# Maintainer:
# 1. Squash merge or regular merge
# 2. Delete branch
# 3. Issue closes automatically
```

---

### 2. Protected Branches
```bash
# Set up on GitHub:
# Repo Settings → Branches → Add rule

# Configure requirements:
- Require pull request review (minimum 1-2)
- Require status checks to pass (CI/CD)
- Require branches to be up to date
- Require code owners review
```

**Git commands respect these:**
```bash
# Can't push directly to main (blocked by GitHub)
git push origin main
# rejected: 403 Forbidden

# Must create PA instead
git push origin feature/fix
# Push succeeds, now create PR for review
```

---

### 3. Code Owners
```bash
# Create CODEOWNERS file in repo root
# or .github/CODEOWNERS

# Example CODEOWNERS:
"""
# Default owners
* @owner1 @owner2

# Specific paths
/src/api/ @api-team
/docs/ @documentation-team
/infrastructure/ @devops-team

# Files
*.md @documentation-team
README.md @owner1 @owner2
"""

# Anyone changing these files triggers review request to code owners
```

---

## GitHub Actions & Automation

### 1. Create CI/CD Workflow
```yaml
# .github/workflows/test.yml

name: Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm test
      - name: Run linter
        run: npm run lint
```

**Trigger:** Every push to main/develop or PR to main automatically runs tests

---

### 2. Automatic Deployment
```yaml
# .github/workflows/deploy.yml

name: Deploy

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to production
        run: |
          npm install
          npm run build
          # Deploy commands...
```

**Trigger:** When you push tag like `v1.0.0` or push to main, automatically deploys

---

## Security & Best Practices

### 1. Secure Credential Management
```bash
# ❌ NEVER do this:
git commit -m "Add API key: sk-1234567890abcdef"

# ✅ Instead: Use GitHub Secrets
# Settings → Secrets and variables → Actions

# In workflow:
env:
  API_KEY: ${{ secrets.API_KEY }}

# Access in commits as environment variable
# Don't hardcode!
```

---

### 2. GitIgnore Setup
```bash
# Create .gitignore in repo root
echo "node_modules/" >> .gitignore
echo ".env" >> .gitignore
echo "*.log" >> .gitignore
echo "build/" >> .gitignore

# If already committed, remove from tracking
git rm --cached .env
git commit -m "Remove .env from tracking"

# Now .gitignore prevents re-adding
git status  # .env no longer appears
```

---

### 3. SSH Keys for Secure Push/Pull
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"
# or for older systems:
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"

# Copy public key to GitHub
# Settings → SSH and GPG keys → New SSH key
cat ~/.ssh/id_ed25519.pub | pbcopy    # Mac
# or Windows PowerShell:
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub | Set-Clipboard

# Test connection
ssh -T git@github.com

# Use SSH in remote URL
git remote set-url origin git@github.com:username/repo.git
```

---

## Real-World Project Scenarios

### Scenario 1: Team Project with Release Cycle
**Team Setup:**
- 5 developers
- Weekly releases to production
- Need to maintain stability

**Workflow:**
```bash
# Main branches:
# - main: Production code (stable)
# - develop: Integration branch
# - release/*: Release prep
# - feature/*: Feature development
# - hotfix/*: Production bugs

# Developer starts feature:
git checkout -b feature/user-authentication
# Small, focused changes...
git add .
git commit -m "Add JWT authentication"
git push -u origin feature/user-authentication

# Create PR on GitHub
# Team reviews
# Merge to develop once approved

# Release manager prepares release:
git checkout -b release/1.5.0 develop
# Version bumps, final testing...
git commit -m "Release 1.5.0"
git merge release/1.5.0 main
git tag v1.5.0
git push origin main v1.5.0

# Clean up
git merge main develop    # update dev with release
git branch -d release/1.5.0
```

---

### Scenario 2: Large Refactoring with Multiple PRs
**Goal:** Refactor authentication system without breaking features

**Approach:**
```bash
# Parent feature branch
git checkout -b feature/auth-refactor

# Create sub-branches for different parts
git checkout -b feature/auth-refactor/jwt
# Changes to JWT handling...
git commit -m "Refactor JWT validation"
git push -u origin feature/auth-refactor/jwt

# Create PR: feature/auth-refactor/jwt → feature/auth-refactor
# Review and merge (to feature/auth-refactor)

# Next sub-branch
git checkout -b feature/auth-refactor/session
# Session handling changes...
git commit -m "Refactor session management"
git push -u origin feature/auth-refactor/session

# Create PR: feature/auth-refactor/session → feature/auth-refactor
# Review and merge

# Finally merge parent to main
# PR: feature/auth-refactor → main
# Contains all sub-changes in logical commits
```

---

### Scenario 3: Hotfix for Production Issue
**Problem:** Bug in production needs immediate fix. Can't wait for develop cycle.

```bash
# Create hotfix branch from main
git checkout main
git pull
git checkout -b hotfix/payment-processing

# Make minimal fix
# Test thoroughly
git add payment.js
git commit -m "Fix: Handle null payment response"

# Create PR immediately
gh pr create --title "HOTFIX: Payment processing error" \
             --body "Production issue - #456"

# Fast-track approval and merge
# Merge to main

# Also merge back to develop
git checkout develop
git pull
git merge main
git push

# Tag hotfix
git tag v1.0.1
git push origin v1.0.1
```

---

### Scenario 4: Revert Bad Release
**Problem:** Production version has critical bug. Earlier version was stable.

```bash
# Option 1: Direct revert (if recent)
git log --oneline | head -10
# abc1234 Release 1.2.0 (bad)
# def5678 Release 1.1.9 (good)

git revert abc1234
git commit -m "Revert: 1.2.0 caused API failures"
git tag v1.2.1
git push origin main v1.2.1

# Option 2: Hotfix from stable tag
git checkout -b hotfix/rollback v1.1.9
# Make necessary patches...
git tag v1.1.10
git push origin v1.1.10
```

---

### Scenario 5: Open Source Community Contributions
**Your Role:** Merge community PRs after review

```bash
# Review incoming PR
git fetch origin pull/234/head:community-pr-234
git checkout community-pr-234

# Review code locally
# Run tests
npm test

# If good: merge and push
git checkout main
git merge --squash community-pr-234 -m "Merge PR #234: Add export to CSV"
git push origin main

# GitHub auto-closes PR #234
# Add contributor to README
# Create discussion thread thanking contributor
```

---

### Scenario 6: Disaster Recovery - Restore Deleted Branch
**Problem:** Someone deleted important branch!

```bash
# Check reflog
git reflog

# Find deletion
# abc1234 HEAD@{5}: checkout: moving from feature/deleted -> main
# def5678 HEAD@{6}: commit: Important feature complete

# Recover
git checkout -b recovered-feature def5678
git push origin recovered-feature

# Confirm restoration
git log recovered-feature --oneline
# All commits intact!
```

---

## GitHub CLI Advanced Commands

```bash
# Create and manage issues
gh issue create --title "Bug: Login fails on mobile"
gh issue list --assignee @me
gh issue view 123
gh issue close 123

# PR operations
gh pr list --state open
gh pr view 42 --web          # Open in browser
gh pr review 42 --approve
gh pr review 42 --request-changes
gh pr checks 42              # View test status

# Release management
gh release create v1.0.0 --generate-notes
gh release upload v1.0.0 build.zip
```

---

## Automation Examples

### Auto-format on Commit
```bash
# .git/hooks/pre-commit
#!/bin/bash
npm run format
git add .
```

---

### Auto-update Dependencies Weekly
```yaml
# .github/workflows/update-deps.yml
name: Update Dependencies
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Update npm packages
        run: npm update
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v4
        with:
          commit-message: 'chore: update dependencies'
          title: 'Chore: Weekly dependency update'
```

---

## Key Takeaways for GitHub Workflows
✅ Use forks for open source contributions  
✅ Protect main branch with PR requirements  
✅ Automate tests with GitHub Actions  
✅ Link commits to issues for tracking  
✅ Use semantic versioning for releases  
✅ Maintain clear commit history with meaningful messages  
✅ Review PRs thoroughly before merging  
✅ Use GitHub Secrets for sensitive data  
✅ Consider code owners for large teams  
✅ Tag releases and maintain changelog  
