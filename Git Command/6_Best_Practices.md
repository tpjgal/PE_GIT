# Git & GitHub Best Practices

## Table of Contents
1. [Commit Best Practices](#commit-best-practices)
2. [Branch Naming & Management](#branch-naming--management)
3. [Code Review Practices](#code-review-practices)
4. [Workflow & Team Practices](#workflow--team-practices)
5. [Security Best Practices](#security-best-practices)
6. [Release Management](#release-management)
7. [Communication & Documentation](#communication--documentation)
8. [Performance & Optimization](#performance--optimization)

---

## Commit Best Practices

### 1. Write Clear, Descriptive Commit Messages

**Format: Subject Line + Body**
```
[Type]: Brief description (50 chars max)

Detailed explanation of why this change is needed.
- Key point 1
- Key point 2

Fixes #123
```

**Commit Types:**
```
feat:     New feature
fix:      Bug fix
docs:     Documentation changes
style:    Code style (formatting, missing semicolons, etc.)
refactor: Code restructuring without feature changes
perf:     Performance improvements
test:     Test additions/modifications
chore:    Build, CI/CD, dependency updates
```

**Examples - Good vs Bad:**
```bash
# ❌ BAD
git commit -m "fixed stuff"
git commit -m "asdf"
git commit -m "Updated"

# ✅ GOOD
git commit -m "fix: resolve login redirect loop on mobile devices"
git commit -m "feat: add dark mode toggle to settings menu"
git commit -m "docs: update README installation instructions"
git commit -m "perf: optimize database query in user dashboard"
```

### 2. Commit Size & Scope

**✅ Commit One Thing:**
```bash
# ❌ TOO MUCH
git commit -m "Update login, add search, fix typo in header"

# ✅ GOOD
git commit -m "feat: add login functionality"
git add search.js
git commit -m "feat: implement product search"
git add header.txt
git commit -m "fix: correct typo in header text"
```

**Reasons for Small Commits:**
- Easier to review and understand
- Simpler to debug and revert if needed
- Better for blame/history inspection
- Helps locate bugs with git bisect

### 3. Staging Before Commit

```bash
# Review changes
git status

# Check specific file changes
git diff file.js

# Stage changes interactively
git add -p
# Choose which hunks to stage

# Verify staging
git diff --staged

# Commit
git commit -m "message"
```

### 4. Don't Commit These

```bash
# Create/update .gitignore
node_modules/
*.log
.env
.env.local
.DS_Store
dist/
build/
*.swp
.idea/
.vscode/settings.json
```

**Password/API Keys:**
```bash
# ❌ NEVER
git commit -m "Add API key: sk_live_1234567890"

# ✅ Use environment variables
# .env (in .gitignore)
API_KEY=sk_live_1234567890

# Code
const apiKey = process.env.API_KEY
```

### 5. Commit Frequency

**Best Practice:**
- **Commit daily minimum** - backs up locally
- **Commit multiple times per day** - for each logical change
- **Don't commit incomplete work** - unless stashing/branching

**Daily Workflow Example:**
```bash
# Morning: start fresh
git checkout -b feature/user-auth
git add .
git commit -m "feat: start user authentication module"

# Midday: checkpoint
git add .
git commit -m "feat: implement JWT generation"

# Afternoon: ready
git add .
git commit -m "feat: add login validation"

# Before pushing:
git rebase -i HEAD~3  # Clean up if needed
git push
```

---

## Branch Naming & Management

### 1. Branch Naming Conventions

**Pattern: `<type>/<short-description>`**

```bash
# Features
feature/user-authentication
feature/payment-processing
feature/dark-mode-toggle

# Bugfixes
bugfix/login-redirect-loop
bugfix/null-pointer-exception
bugfix/memory-leak-profile

# Hotfixes
hotfix/critical-payment-error
hotfix/security-vulnerability

# Releases
release/1.2.0
release/2.0.0-beta

# Maintenance
chore/update-dependencies
chore/lint-configuration

# Developer experiments (not for shared branches)
personal/andrew-testing
exp/new-algorithm
```

**Rules:**
- Use lowercase
- Use hyphens (not underscores or spaces)
- Keep concise (~30 chars)
- Descriptive but not verbose
- Include issue number if applicable: `feature/add-export-#456`

### 2. Branch Lifecycle

```bash
# Create
git checkout -b feature/user-profile

# Work
git add .
git commit -m "feat: add profile picture upload"

# Push before closing day
git push -u origin feature/user-profile

# Create PR on GitHub

# Merge when approved
# Delete remote branch on GitHub

# Clean up local
git checkout main
git pull
git branch -d feature/user-profile
```

### 3. Keep Branches Synchronized

```bash
# Before starting work
git checkout main
git pull

# During feature work
git fetch origin
git diff main FETCH_HEAD  # See what changed

# Before merging
git fetch origin
git rebase origin/main    # Stay updated
git push
```

### 4. Delete Merged Branches

```bash
# List merged branches
git branch --merged

# Delete safely
git branch -d merged-branch

# Clean up all merged
git branch --merged | grep -v '\*' | xargs -n 1 git branch -d

# Clean up remote tracking references
git fetch --prune
git remote prune origin
```

---

## Code Review Practices

### 1. Creating a PR for Review

**Pull Request Checklist:**
```markdown
## Description
Brief explanation of what this PR does.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No console.log or debug code
- [ ] No hardcoded secrets/API keys
```

**Example PR Title:**
```
✅ GOOD
"feat: Add export to CSV functionality"
"fix: Resolve memory leak in user profile"

❌ BAD
"Update stuff"
"Work in progress"
"Fixed"
```

### 2. Reviewing Others' Code

**Before Approving - Check:**
- [ ] Code solves the stated problem
- [ ] Tests are included and passing
- [ ] No obvious bugs or issues
- [ ] Code follows project style
- [ ] No hardcoded secrets
- [ ] Performance implications considered
- [ ] Docs/comments adequate

**Constructive Feedback:**
```
# ❌ Unhelpful
"This is bad"
"Why would you do this?"

# ✅ Helpful
"This could be more efficient. Consider using Set instead of Array
to avoid O(n) lookup time. See: [link]"

"Great work! One suggestion: could we extract this logic
into a helper function to improve reusability?"
```

### 3. Responding to Review Feedback

```bash
# Reviewer requests changes
# 1. Don't create new branch or stash

# 2. Make the requested changes
git add .
git commit -m "Address review: improve error handling"

# 3. Push to same branch
git push

# 4. Re-request review on GitHub
# (Don't create new PR)
```

### 4. Review Turnaround

**Best Practice:**
- Review PRs within **24 business hours**
- Main/critical PRs: Review within **4 hours**
- Respond to feedback promptly
- Don't let PRs languish

---

## Workflow & Team Practices

### 1. Daily Development Pattern

```bash
# Start day
git checkout main
git pull                    # Get overnight changes

# Start feature
git checkout -b feature/my-feature

# Work (throughout day)
git add .
git commit -m "feat: part 1"

git add .
git commit -m "feat: part 2"

# Before wrapping up
git pull --rebase origin main    # Stay synced
git log --oneline -5             # Review your work

# If ready to merge
git push -u origin feature/my-feature
# Create PR, request review

# If continuing next day
git push                    # Back up your work
```

### 2. Handling Interruptions

**Scenario: Important bug fix needed mid-feature**

```bash
# Save your work
git stash save "WIP: feature in progress"

# Fix bug
git checkout -b bugfix/critical-issue
# Make fix
git add .
git commit -m "fix: critical production bug"
git push
# Create and merge PR

# Back to feature
git checkout feature/my-feature
git stash pop

# Continue work
```

### 3. Communication

**Before Starting Big Changes:**
```
"I'm going to refactor the authentication module. 
This might take 3 days and will touch:
- auth/login.js
- auth/session.js
- api/routes/auth.js

I'll keep the branch updated regularly. 
ETA: merge by Friday."
```

**When Blocked:**
```
"I'm blocked on PR #456 (waiting for review).
Starting on smaller task: update error messages.
Can someone review when available?"
```

### 4. Collaboration on Same Feature

**If Multiple People Work on Same Feature:**

```bash
# Shared feature branch
git checkout -b feature/payment-system

# Person A
git checkout -b feature/payment-system/stripe-integration
# Work...
git push

# Person B
git checkout -b feature/payment-system/payment-validation
# Work...
git push

# Create sub-PRs to shared feature branch
# Then PR from shared feature branch to main
```

---

## Security Best Practices

### 1. Never Commit Secrets

**Before Committing:**
```bash
# Search for secrets
git log -p | grep -i "password\|api\|key\|token"

# In current changes
git diff | grep -i "password\|api\|key\|token"
```

**If You Accidentally Committed Secrets:**
```bash
# 1. Immediately rotate the secret
# 2. Remove from repo

# Option A: If not pushed to shared branch
git reset --soft HEAD~1
git reset file.js
# Edit to remove secret
git add file.js
git commit -m "fix: remove hardcoded secret"

# Option B: If pushed (use BFG)
bfg --delete-files secrets.txt
git reflog expire --expire=now --all
git gc --prune=now
git push --force-with-lease
```

### 2. SSH Keys Instead of Passwords

```bash
# Generate SSH key (do once)
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to GitHub: Settings → SSH Keys

# Use SSH in remote
git remote set-url origin git@github.com:user/repo.git

# No more password prompts!
git push  # Works without password
```

### 3. Protect Sensitive Branches

```bash
# On GitHub: Settings → Branches
# Add branch protection rules for:
- main
- develop
- release/*

# Require:
- Pull request review (minimum 1-2 people)
- All conversations resolved
- Status checks passing (tests/linting)
- Branch up to date
```

### 4. Code Owners

**Create `.github/CODEOWNERS`:**
```
# Default reviewers
* @senior-dev @team-lead

# Specific paths need specific reviewers
/src/auth/ @security-team
/src/payments/ @finance-team
/docs/ @documentation-team
```

---

## Release Management

### 1. Version Numbering

**Semantic Versioning: `MAJOR.MINOR.PATCH`**

```
1.0.0     Initial release
1.1.0     New features (backward compatible)
1.1.1     Bug fix (backward compatible)
2.0.0     Breaking changes

1.2.0-beta.1      Beta release
2.0.0-rc.1        Release candidate
```

**When to Bump:**
```bash
# PATCH (1.0.0 → 1.0.1)
- Bug fixes
- Minor improvements
- No breaking changes

# MINOR (1.0.0 → 1.1.0)
- New features
- Backward compatible changes
- No breaking changes

# MAJOR (1.0.0 → 2.0.0)
- Breaking API changes
- Major refactoring
- Removed features
```

### 2. Release Process

```bash
# 1. Prepare release branch
git checkout -b release/1.2.0

# 2. Update version numbers
# package.json, VERSION file, etc.
git add .
git commit -m "chore: bump version to 1.2.0"

# 3. Testing and final fixes
npm test
# Fix any last-minute issues...

# 4. Merge to main
git checkout main
git merge release/1.2.0
git tag -a v1.2.0 -m "Release 1.2.0"

# 5. Merge back to develop
git checkout develop
git merge release/1.2.0

# 6. Push everything
git push origin main develop v1.2.0

# 7. Clean up
git branch -d release/1.2.0

# 8. GitHub: Create release from tag with changelog
```

### 3. Hotfix Process

```bash
# Critical bug in production (version 1.2.0)
git checkout -b hotfix/1.2.1 v1.2.0

# Make minimal fix
git add .
git commit -m "fix: critical payment processing error"

# Merge to main
git checkout main
git merge hotfix/1.2.1
git tag -a v1.2.1 -m "Hotfix 1.2.1"

# Also merge to develop
git checkout develop
git merge hotfix/1.2.1

# Push
git push origin main develop v1.2.1

# Clean up
git branch -d hotfix/1.2.1
```

### 4. Changelog Maintenance

**Keep a CHANGELOG.md:**
```markdown
# Changelog

## [1.2.0] - 2024-03-28
### Added
- Export to CSV functionality
- Dark mode toggle

### Fixed
- Memory leak in user profile
- Login redirect issue on mobile

### Changed
- Updated dependencies

### Breaking Changes
- Removed deprecated API endpoints

---

## [1.1.0] - 2024-03-21
### Added
- User authentication
- Email verification
```

---

## Communication & Documentation

### 1. Commit Messages as Documentation

```bash
# Include the "why"
git commit -m "refactor: extract auth logic to separate module

Previously, auth logic was mixed with route handlers,
making it hard to test and reuse. This change centralizes
all authentication logic in a dedicated module.

See ticket #456 for requirements."
```

### 2. README Best Practices

```markdown
# Project Name

Brief description of what the project does.

## Features
- Feature 1
- Feature 2

## Installation
```bash
git clone <repo>
cd project
npm install
npm start
```

## Usage
```javascript
// Example code
```

## Contributing
- Read CONTRIBUTING.md
- Follow commit message guidelines
- Submit PR with tests

## License
MIT

## Team
- @developer1 - Backend
- @developer2 - Frontend
```

### 3. PR Descriptions

**Always Include:**
- What problem does this solve?
- How does it solve it?
- Any relevant links/issues
- Testing performed
- Screenshots if UI changes

```markdown
## Problem
Users couldn't export their data, causing complaints from 
large corporate clients.

## Solution
Added CSV export functionality with:
- Flexible column selection
- Batch export capability
- Email delivery option

## Fixes #456

## Testing
- [x] Unit tests (95% coverage)
- [x] Integration tests
- [x] Manual testing on Chrome/Firefox/Safari
- [x] Tested with 10MB+ datasets

## Screenshots
[attachment: before.png]
[attachment: after.png]
```

---

## Performance & Optimization

### 1. Repository Maintenance

```bash
# Regular cleanup (monthly)
git gc --aggressive

# Remove unused branches
git branch --merged | xargs git branch -d

# Clean untracked files
git clean -fd
```

### 2. Large File Handling

**For large files, use Git LFS:**
```bash
# Install
brew install git-lfs

# Track files
git lfs track "*.zip"
git lfs track "*.psd"

# Commit normally
git add large-file.zip
git commit -m "Add design files"

# Git handles efficiently
```

### 3. Shallow Cloning for Large Repos

```bash
# Clone only recent history
git clone --depth 1 https://github.com/huge-project/repo.git

# Later, get full history
git fetch --unshallow
```

### 4. Git Ignore Optimization

```bash
# Exclude heavy directories
node_modules/
venv/
.gradle/
build/
dist/

# Exclude OS files
.DS_Store
Thumbs.db

# Exclude IDE settings
.vscode/
.idea/

# Exclude environment files
.env
.env.local
.env.*.local
```

---

## Common Anti-Patterns to Avoid

### ❌ Don't Do This

```bash
# 1. Committing to main directly
git checkout main
# Make changes
git commit -m "quick fix"
# ✅ Instead: Use feature branch

# 2. Force pushing to shared branches
git push --force origin main
# ✅ Instead: Use --force-with-lease or revert
git push --force-with-lease
git revert abc1234

# 3. Huge commits with many changes
# ✅ Instead: Commit one thing at a time

# 4. Generic commit messages
git commit -m "update"
# ✅ Instead: Specific descriptions

# 5. Leaving local branches around
# ✅ Instead: Delete after merging

# 6. Not pulling before pushing
# ✅ Instead: Always git pull first

# 7. Rewriting public history
git rebase origin/main && git push --force
# ✅ Instead: Only on your own branches
```

---

## Workflow Checklist

### Before Starting Work
- [ ] `git checkout main && git pull`
- [ ] Create feature branch: `git checkout -b feature/x`
- [ ] Communicate with team if big change

### During Work
- [ ] Commit frequently (multiple times/day)
- [ ] Write clear commit messages
- [ ] Test before committing
- [ ] Push daily as backup

### Before Pushing
- [ ] `git status` to verify changes
- [ ] `git diff --staged` to review
- [ ] Run tests: `npm test`
- [ ] Run linter: `npm run lint`
- [ ] `git log -n 5` to review commits

### Creating PR
- [ ] Descriptive title
- [ ] Clear description
- [ ] Link to related issues
- [ ] Self-review first
- [ ] Request appropriate reviewers

### Code Review
- [ ] Test locally: `gh pr checkout 42`
- [ ] Review all changes
- [ ] Check for style issues
- [ ] Verify tests pass
- [ ] Approve or request changes

### Merging
- [ ] Ensure all reviews complete
- [ ] All checks passing
- [ ] Branch up to date
- [ ] Squash if needed
- [ ] Delete branch after merge

### Cleanup
- [ ] Delete local branch: `git branch -d feature/x`
- [ ] Fetch to clean remote tracking: `git fetch --prune`

---

## Team Meeting Talking Points

**Weekly Check-in:**
- Any PRs waiting for review?
- Blocked on anything?
- Any branch conflicts brewing?
- Release timeline clear?

**Before Major Changes:**
- Who's working on what?
- Any overlapping changes?
- Coordination needed?
- Timeline expectations?

**After Incidents:**
- What went wrong?
- How do we prevent it?
- Process changes needed?
- Documentation gaps?

---

## Resources for Your Team

**Share These:**
1. This Best Practices guide
2. [Git Basics](1_Git_Basics.md) for new developers
3. Your project's CONTRIBUTING.md
4. Your project's commit message guidelines

**Setup Each Developer Has:**
```bash
# Configure Git
git config --global user.name "Name"
git config --global user.email "email@example.com"

# Setup SSH
ssh-keygen -t ed25519 -C "email@example.com"
# Add public key to GitHub

# Useful aliases
git config --global alias.st status
git config --global alias.lg "log --graph --oneline --all"
git config --global alias.amend "commit --amend --no-edit"
```

---

## Quick Reference - Do's and Don'ts

| ✅ DO | ❌ DON'T |
|------|---------|
| Commit frequently | Wait days to commit |
| Write clear messages | Use "fix", "update", "asdf" |
| Use feature branches | Commit directly to main |
| Review before pushing | Push without checking |
| Pull before work | Assume nothing changed |
| Small commits | Everything in one commit |
| Delete merged branches | Let them accumulate |
| Back up with push | Only keep local copy |
| Communicate changes | Surprise team with big PRs |
| Test before committing | Find bugs in production |
| Use `.gitignore` | Commit secrets/temp files |
| Document releases | Unclear version history |

---

## Measuring Success

**Signs Your Team Has Good Git Practices:**
- ✅ Code reviews happen quickly (24 hrs)
- ✅ Main is always deployable
- ✅ No mysterious "Why did this happen?" moments
- ✅ Feature rollbacks are simple
- ✅ New developers contribute quickly
- ✅ Release process is smooth
- ✅ Security incidents are rare
- ✅ Git history is readable and useful
- ✅ Merge conflicts are minimal
- ✅ Team moves fast with confidence

---

**Remember:** Good Git practices aren't about rules—they're about making your team more productive, safer, and happier. Tailor these practices to your team's needs.
