# Git Intermediate - Branching, Merging & Team Work

## Table of Contents
1. [Understanding Branches](#understanding-branches)
2. [Branching Commands](#branching-commands)
3. [Merging](#merging)
4. [Pull Requests](#pull-requests)
5. [Collaborative Workflows](#collaborative-workflows)
6. [Practical Scenarios](#practical-scenarios)

---

## Understanding Branches

### What is a Branch?
A branch is an independent line of development. Think of it as a parallel version of your project.

```
main:    A → B → C → D
                      ↑ current version

feature: A → B → E → F
                ↑ separate work
```

**Why Use Branches?**
- Multiple people can work on different features simultaneously
- Keep main/stable code separate from experimental work
- Easy to create, test, and discard alternatives
- Organize work by feature, bugfix, or experimentation

---

## Branching Commands

### 1. Create a Branch
```bash
git branch feature-name           # Create branch locally
git branch                        # List local branches
git branch -a                     # List all branches (local + remote)
git branch -v                     # Show branches with last commit
```

**Explanation:** Creates a new pointer at your current commit. Doesn't switch to it yet.

---

### 2. Switch Branches
```bash
git checkout branch-name          # Switch to existing branch
git switch branch-name            # Newer syntax (Git 2.23+)
git checkout -b new-branch        # Create and switch in one command
git switch -c new-branch          # Same as above, newer syntax
```

**Explanation:** Switches your working directory to a different branch. All files update to match that branch's state.

**Scenario - Managing Multiple Features:**
```bash
# Working on Feature A
git checkout -b feature/payment
# Make changes and commits...

# Need to switch to Feature B
git checkout feature/reporting
# Your working directory now shows Feature B's state

# Back to Feature A
git checkout feature/payment
# Feature B changes are still saved, just not visible
```

---

### 3. Delete Branches
```bash
git branch -d branch-name         # Delete local branch (safe - warns if not merged)
git branch -D branch-name         # Force delete local branch
git push origin --delete branch-name  # Delete remote branch
```

**Explanation:** Clean up branches after they're merged or no longer needed.

---

### 4. Rename Branch
```bash
git branch -m old-name new-name   # Rename locally
git push origin --delete old-name # Delete old remote branch
git push origin new-name          # Push renamed branch
```

---

## Merging

### 1. Merge Branch
```bash
git merge branch-name             # Merge specified branch into current branch
git merge -m "Custom message" branch-name  # Merge with custom commit message
```

**Explanation:** Combines changes from one branch into another. Usually you merge feature branches into main.

**Visual Example:**
```
feature:     E → F
            /
main:  A → B → C → D → M (merge commit)
```

**Scenario - Merging a Completed Feature:**
```bash
# On feature/payment branch, last changes committed
git log --oneline
# 4a5b6c Add payment confirmation email
# 3x2y1z Implement payment processing
# mainbranch commits...

# Switch to main
git checkout main

# Merge feature into main
git merge feature/payment

# Now main has all of feature/payment's changes
```

---

### 2. Rebase (Alternative to Merge)
```bash
git rebase main                   # Replay feature changes on top of main
# Use with caution - rewrites history!
```

**Explanation:** Instead of creating a merge commit, rebase replays your commits on top of the target branch. Results in a cleaner, linear history.

**Visual Example:**
```
feature:     E → F
            /
main:  A → B → C → D

After rebase:
main:  A → B → C → D
feature:              E' → F'  (replayed commits)
```

**When to Use Rebase vs Merge:**
- **Merge:** When multiple people are working on the branch (safer)
- **Rebase:** For feature branches with your solo work (cleaner history)

---

## Pull Requests

### Why Use Pull Requests?
Pull Requests (PRs) enable code review before merging. Not a Git command, but a GitHub feature.

### Basic PR Workflow
```bash
# Push your feature branch
git push -u origin feature/new-search

# Do NOT merge locally!
# Instead:
# 1. Go to GitHub
# 2. GitHub prompts "Create Pull Request"
# 3. Add title and description
# 4. Team reviews code
# 5. Request changes or approve
# 6. GitHub "Merge" button does final merge
# 7. Delete branch
```

### After PR is Merged
```bash
# Switch back to main
git checkout main

# Get the merged changes
git pull

# Delete local feature branch
git branch -d feature/new-search
```

---

## Collaborative Workflows

### Git Flow (Popular Team Workflow)
```
main     A → B → (releases only)
         ↑
release  ← (hotfixes, release prep)
         ↑
dev      C → D → (integration branch)
         ↑
feature  E → F → (feature work)
```

**Branches:**
- `main` - Production-ready code, only updated by releases
- `release` - Release preparation and hotfixes
- `dev` - Integration branch where features merge
- `feature/feature-name` - Individual feature work

---

### Feature Branch Workflow (Simpler)
```
main     A → B → C (merge PRs here)
         ↑   ↑   ↑
       feature1, feature2, feature3
```

**Simpler workflow:**
1. Create feature branch from main
2. Work on feature
3. Push and create Pull Request
4. Code review and merge to main
5. Delete feature branch

---

## Practical Scenarios

### Scenario 1: Team Member Updates Your Feature Branch
**Problem:** Your teammates pushed changes to the main branch while you were working on a feature. How do you get those changes?

```bash
# You're on feature/user-auth
git status

# Get latest main changes
git fetch origin

# Option A: Rebase your work on new main
git rebase origin/main
# Replays your feature commits on top of updated main

# Option B: Merge main into your branch
git merge origin/main
# Combines main's new changes into your branch

# Resolve any conflicts if they arise
git add .
git commit -m "Merge latest main changes"

# Push your updated branch
git push
```

---

### Scenario 2: Resolving Merge Conflicts
**Problem:** Two people edited the same file differently. Git can't automatically merge.

```bash
# During merge or rebase
# Git shows: CONFLICT (content merge conflict)

# 1. Check status
git status
# Shows conflicted files: both modified: app.js

# 2. Open conflicted file - it looks like:
"""
function authenticate(user) {
<<<<<<< HEAD
  return validateToken(user.token);
=======
  return checkCredentials(user.email, user.password);
>>>>>>> feature/new-auth
}
"""

# 3. Edit to resolve (pick one, both, or a combination)
:
function authenticate(user) {
  let isValid = validateToken(user.token);
  if (!isValid) {
    isValid = checkCredentials(user.email, user.password);
  }
  return isValid;
}
"""

# 4. Mark as resolved
git add app.js

# 5. Complete the merge
git commit -m "Resolve merge conflict in authentication"

# Or if rebasing
git rebase --continue
```

**Explanation:** Merge conflicts happen when the same code is edited in different ways. Git needs you to decide which version is correct (or combine them).

---

### Scenario 3: Accidentally Committed to Main Directly
**Problem:** You made 3 commits directly on main instead of a feature branch. You need to move them to a new branch.

```bash
# Current state: main has your 3 commits
# Another branch still points to old main

git log --oneline
# 1a2b3c Your third change
# 4d5e6f Your second change
# 7g8h9i Your first change
# j0k1l2 Original main commit

# Solution: Create branch from current position, reset main

# 1. Create a branch with your work
git branch feature/my-work

# 2. Reset main to before your commits
git reset --hard j0k1l2

# 3. Switch to your feature branch
git checkout feature/my-work

# Now main is back to original state
# Your commits are safely on feature/my-work
```

---

### Scenario 4: Working on Multiple Features Simultaneously
```bash
# Feature 1: Search functionality
git checkout -b feature/search
# Make commits...
git add .
git commit -m "Add search UI"

# Need to switch to Feature 2 quickly
# Feature 1 is saved as-is
git checkout -b feature/notifications
# Make commits...
git add .
git commit -m "Add notification system"

# Back to Feature 1
git checkout feature/search
# All your search commits are still here
# Continue working...
git add .
git commit -m "Add search API integration"

# Verify each branch has correct commits
git log --oneline --all --graph
```

---

### Scenario 5: Reviewing Changes Before Pushing
```bash
# Made changes on your feature branch
git status

# See all changes compared to main
git diff main

# See just the committed changes
git log main..feature/current

# Before pushing, view what's actually being pushed
git log origin/feature/current..HEAD

# If looks good
git push

# If not ready, keep committing before push
```

---

### Scenario 6: Syncing Fork with Upstream
**Problem:** You forked a project on GitHub. The original project (upstream) has new changes.

```bash
# Add upstream remote
git remote add upstream https://github.com/original-owner/project.git

# Verify remotes
git remote -v
# origin - your fork
# upstream - original project

# Fetch upstream changes
git fetch upstream

# Rebase your work on latest upstream
git rebase upstream/main

# Update your fork
git push origin main -f (force push - use carefully!)

# For future PRs, your changes will be on latest code
```

---

## Advanced Branch Patterns

### Hotfix Pattern
```
main (production)
↑
hotfix/critical-bug (branched from main)
  - Fix bug
  - Merge back to main
  - Also merge to dev
```

**When:** Critical bug in production that needs immediate fix

```bash
# On main (production)
git checkout -b hotfix/payment-error

# Make minimal fix
git add .
git commit -m "Fix payment processing error"

# Merge back to main
git checkout main
git merge hotfix/payment-error

# Also update dev branch
git checkout dev
git merge hotfix/payment-error

# Delete hotfix branch
git branch -d hotfix/payment-error
```

---

### Release Pattern
```
dev (development)
↓
release/1.0.0
  - Version bumps
  - Bug fixes only
  - Merge to main
  - Tag for release
```

**When:** Preparing code for production release

```bash
git checkout -b release/1.0.0
# Update version numbers
# Apply critical bug fixes only
git commit -m "Bump version to 1.0.0"

git checkout main
git merge release/1.0.0
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

---

## Branch Maintenance Commands

```bash
git branch -m old-name new-name  # Rename branch
git branch --merged              # Show merged branches (safe to delete)
git branch --no-merged           # Show unmerged branches
git branch -d $(git branch --merged | grep -v '*')  # Delete all merged branches

# Clean up stale remote references
git fetch -p (prune)
```

---

## Key Takeaways
✅ Use Feature branches for new work  
✅ Keep main branch production-ready  
✅ Use meaningful branch names: `feature/`, `bugfix/`, `hotfix/`  
✅ Review code with Pull Requests before merging  
✅ Resolve conflicts promptly  
✅ Delete merged branches to keep things tidy  
