# Git Advanced - Power User Techniques

## Table of Contents
1. [Advanced History Inspection](#advanced-history-inspection)
2. [Rewriting History](#rewriting-history)
3. [Stashing](#stashing)
4. [Cherry Picking](#cherry-picking)
5. [Tags and Releases](#tags-and-releases)
6. [Advanced Merging](#advanced-merging)
7. [Debugging with Git](#debugging-with-git)
8. [Complex Scenarios](#complex-scenarios)
9. [Performance Optimization](#performance-optimization)

---

## Advanced History Inspection

### 1. Advanced Log Viewing
```bash
# Visual branch graph
git log --graph --oneline --all --decorate

# Show detailed changes
git log -p --follow -- filename.js

# Find commits by pattern
git log -S "search term" --oneline

# Find who deleted something
git log --diff-filter=D --summary | grep delete

# Commits by specific author in date range
git log --author="John" --since="2024-01-01" --until="2024-12-31"

# Show commits not yet in main
git log main..feature/current

# Show commits in both branches
git log main...feature/current

# Pretty format with custom output
git log --pretty=format:"%h - %an : %s" -n 10
```

---

### 2. Searching History
```bash
# Find commit that introduced a bug (binary search)
git bisect start
git bisect bad          # Current commit is bad
git bisect good v1.0.0  # Last known good version
# Test commits Git suggests...
git bisect bad          # or git bisect good

# Find who changed this line
git blame filename.js

# Find commits affecting specific code
git log -L 10,20:filename.js  # Lines 10-20 history

# Different formats for specific info
git log --name-status          # Show file changes
git log --name-only            # Just file names
git log --stat                 # Statistics for changes
```

**Scenario - Finding When Bug Was Introduced:**
```bash
git bisect start
git bisect bad                 # v2.0.0 has the bug
git bisect good v1.5.0         # v1.5.0 works fine

# Now test each suggested commit
# Repeat until Git pinpoints the exact problematic commit
git bisect log                 # View bisect history
git bisect reset               # Exit bisect mode
```

---

### 3. Show Command Deep Dive
```bash
git show HEAD                  # Latest commit details
git show HEAD~2                # 2 commits ago
git show commit-hash:file.js   # File content at that commit
git show commit-hash --stat    # Summary of what changed
git show --name-status commit-hash  # Files changed (added/modified/deleted)
```

**Explanation:** View any commit's full contents and diffs without needing to checkout.

---

## Rewriting History
⚠️ **WARNING:** Only rewrite history on branches YOU own, before pushing!

### 1. Interactive Rebase
```bash
git rebase -i HEAD~3           # Rebase last 3 commits
git rebase -i origin/main      # Rebase all commits not in origin/main
```

**Interactive Options:**
- `pick` - Keep commit as-is
- `reword` - Keep changes, edit commit message
- `squash` - Combine with previous commit (merge messages)
- `fixup` - Combine with previous commit (discard message)
- `drop` - Remove commit entirely
- `exec` - Run shell command

**Scenario - Cleaning Up Messy Commits:**
```bash
# Your commits look like:
# 1a2b3c Work on feature
# 2c3d4e WIP
# 3d4e5f Fix typo
# 4e5f6g Done with feature

# You want to squash into single commit
git rebase -i HEAD~4

# Change to:
# pick 1a2b3c Work on feature
# squash 2c3d4e WIP
# squash 3d4e5f Fix typo
# squash 4e5f6g Done with feature

# Result: One clean commit with all changes
```

---

### 2. Amend Last Commit
```bash
# Forgot to include a file
git add forgotten-file.js
git commit --amend --no-edit

# Want to change commit message
git commit --amend -m "Correct message"

# Include changes and reword
git add .
git commit --amend -m "New message"
```

**⚠️ Only use before pushing!**

---

### 3. Reset Commits
```bash
# Soft reset: undo commit, keep changes staged
git reset --soft HEAD~1

# Mixed reset (default): undo commit, keep changes unstaged
git reset HEAD~1

# Hard reset: undo commit, DISCARD all changes
git reset --hard HEAD~1

# Reset to specific commit
git reset --hard abc1234
```

**Visual Example:**
```
Before: A → B → C → D (HEAD)

git reset --soft HEAD~2
After:  A → B → C (HEAD) [D's changes are staged]

git reset HEAD~2
After:  A → B → C (HEAD) [D's changes are unstaged]

git reset --hard HEAD~2
After:  A → B (HEAD) [C and D completely removed]
```

---

### 4. Revert (Undo Safely on Public Branches)
```bash
# Undo specific commit by creating new commit
git revert abc1234

# Revert multiple commits
git revert HEAD~3..HEAD

# Revert without committing (review first)
git revert --no-commit abc1234
```

**Explanation:** `revert` is safe for public branches - it creates a NEW commit that undoes changes, instead of rewriting history.

**Scenario - Undo Deployed Code:**
```bash
# Bad commit was deployed to production
git log --oneline | head -5
# abc1234 Add new payment method
# 2d3e4f Fix bug in payment    <- This broke production

# Instead of reset (which rewrites history):
git revert 2d3e4f

# Creates new commit that undoes changes
# Safe to push to production immediately
git push
```

---

## Stashing

### What is Stashing?
Temporarily save work without committing. Useful for switching contexts.

```bash
git stash                      # Save all changes
git stash save "WIP: feature X"  # Save with description
git stash list                 # Show all stashes
git stash show stash@{0}       # Show what's in a stash
git stash pop                  # Apply latest stash and remove it
git stash apply stash@{1}      # Apply specific stash (keep it)
git stash drop stash@{0}       # Delete a stash
git stash clear                # Delete all stashes
```

**Scenario - Interruption During Feature Work:**
```bash
# Working on feature/advanced-search
# Changes not yet committed
git status
# modified: search.js

# Suddenly: "Can you fix the login bug?"
# You're not ready to commit your search changes

# Stash your work
git stash save "WIP: search refinements"

# Switch to bugfix
git checkout -b bugfix/login-error
# Fix and commit...
git commit -m "Fix login redirect"
git push

# Back to your feature
git checkout feature/advanced-search
git stash pop

# Your search changes are back!
```

---

## Cherry Picking

### What is Cherry Picking?
Apply specific commits from one branch to another (without merging the whole branch).

```bash
git cherry-pick abc1234        # Apply commit to current branch
git cherry-pick abc1234 def5678  # Apply multiple commits
git cherry-pick abc1234..def5678  # Apply range of commits
git cherry-pick --continue     # Resume after resolving conflicts
git cherry-pick --abort        # Cancel cherry-pick
```

**Visual Example:**
```
main:       A → B → C
               ↑
feature:    A → B → D → E → F
                       ↑     
                   Cherry-pick E

Result:  main: A → B → C → E'
```

**Scenario - Backporting Bug Fix:**
```bash
# Bug fix is in develop branch
# Need it in production branch too

# On develop: found commit abc1234 fixes bug
git log --oneline | grep "Fix critical bug"
# abc1234 Fix critical bug

# Switch to production branch
git checkout main

# Apply just that bugfix commit
git cherry-pick abc1234

# Now production has the fix without all of develop's changes
git push origin main
```

---

## Tags and Releases

### Creating Tags
```bash
# Lightweight tag (pointer to commit)
git tag v1.0.0

# Annotated tag (full object with metadata)
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag specific commit
git tag -a v1.0.0 abc1234 -m "Release"

# Push tags
git push origin v1.0.0         # Push specific tag
git push origin --tags         # Push all tags

# List tags
git tag                        # List all
git tag -l "v1.*"            # List matching pattern
git show v1.0.0              # Show tag details
```

**Scenario - Creating Release:**
```bash
# Version 1.5.0 is ready
# Tag it for release

git tag -a v1.5.0 -m "Release 1.5.0: Added user profiles"

git push origin v1.5.0

# On GitHub: Releases tab shows this version
# Users can download source code zip for this version
```

---

## Advanced Merging

### 1. Squash Merge
```bash
git merge --squash feature/new-feature

# Combines all commits into one uncommitted change
# You then commit as single commit

git commit -m "Add new feature"
```

**Visual Result:**
```
feature: D → E → F
        /
main:  A → B → C → MERGED (single commit with all changes)
```

**When to Use:**
- Feature branch has many messy commits
- Want clean linear history
- Don't need individual commit history for feature

---

### 2. Merge with Custom Strategy
```bash
git merge -X theirs feature       # If conflicts, prefer their version
git merge -X ours feature        # If conflicts, prefer our version

# For very complex merges
git merge -strategy recursive -X patience feature
```

---

### 3. Three-Way Merge Visualization
```
         Common Ancestor (A)
        /                \
    Ours (B)          Theirs (C)
    
    Git merges B and C, using A as reference
```

---

## Debugging with Git

### 1. Blame - Find Who Changed This
```bash
git blame filename.js

# Who changed line 42?
git blame -L 40,50 filename.js

# Who changed this, ignoring whitespace?
git blame -w filename.js

# Show just the last change
git blame --date=short filename.js
```

**Example Output:**
```
abc1234d (John Doe 2024-01-15) function myFunction() {
def5678c (Jane Smith 2024-02-01)   return calculate();
ghi9012a (John Doe 2024-01-15) }
```

---

### 2. Bisect - Binary Search for Bug
```bash
git bisect start
git bisect bad                # Current is broken
git bisect good v1.0.0        # Last known good version

# Test the commit Git offers
npm test

# Mark result
git bisect good  # or git bisect bad

# Repeat until found!
git bisect log   # View bisect history
git bisect reset # Exit bisect
```

---

### 3. Reflog - Recovery Tool
```bash
git reflog                   # Show all ref changes
git log -g                   # Similar to reflog
git checkout @{2}           # Go back to 2 moves ago
git reset --hard @{5}       # Go back to 5 moves ago
```

**Scenario - Recovered Accidentally Deleted Work:**
```bash
# Accidentally did: git reset --hard HEAD~5
# Panicked!

# View reflog
git reflog
# abc1234 HEAD@{0}: reset: moving to HEAD~5
# def5678 HEAD@{1}: commit: Important work
# ghi9012 HEAD@{2}: commit: More important work

# Recover!
git reset --hard def5678

# All your "deleted" commits are back!
```

---

## Complex Scenarios

### Scenario 1: Splitting a Commit
**Problem:** One commit has 3 different types of changes. Need to split into 3 commits.

```bash
# Identify the commit
git log --oneline | head -5
# abc1234 Mixed changes

# Interactive rebase
git rebase -i HEAD~1

# Mark as 'edit'
# edit abc1234 Mixed changes

# Git stops at that commit
git reset HEAD~1

# Now unstaged. Selectively stage parts:
git add filename1.js
git commit -m "Feature A"

git add filename2.js
git commit -m "Bugfix B"

git add filename3.js
git commit -m "Refactoring C"

git rebase --continue
```

---

### Scenario 2: Combining Branches' Changes
**Problem:** main has commits you need, AND feature has commits you need. Merge in specific order.

```bash
# You're on feature/complex
# Want all of main + all of current

# Rebase approach: replay feature on main
git rebase main

# Or merge: combine histories
git merge main

# Or cherry-pick: apply specific commits
git cherry-pick main~3..main    # Last 3 commits from main
```

---

### Scenario 3: Large File Cleanup (BFG Repo-Cleaner)
**Problem:** Accidentally committed large binary files. They're in history and bloating repo.

```bash
# Install BFG (external tool)
brew install bfg

# Remove files from entire history
bfg --delete-files build.zip

# Clean up
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push (DESTRUCTIVE - only if agreed with team)
git push --force
```

⚠️ **Only do this on agreed-upon projects!**

---

### Scenario 4: Migrating Repository to Different Remote
```bash
# Clone with --mirror to get everything
git clone --mirror https://oldserver/project.git project.git

# Push to new location
cd project.git
git push --mirror https://newserver/project.git

# On your workstation, point to new remote
git remote set-url origin https://newserver/project.git
git pull
```

---

## Performance Optimization

### 1. Shallow Cloning for Large Repos
```bash
# Only get recent history (much faster)
git clone --depth 1 https://github.com/huge-project/repo.git

# Later, pull full history if needed
git fetch --unshallow
```

---

### 2. Garbage Collection
```bash
# Optimize repository storage
git gc --aggressive

# Prune stale objects
git prune

# Clean everything
git clean -fd           # Remove untracked files and directories
git reset --hard        # Reset to HEAD
```

---

### 3. Partial Clone (Git 2.20+)
```bash
# Clone only tree objects (no file contents)
git clone --filter=blob:none https://github.com/project.git

# Downloads blobs on-demand
# Great for very large repos
```

---

### 4. Working with Large Files (Git LFS)
```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.zip"

# Now Git LFS handles large files efficiently
git add large-file.zip
git commit -m "Add large file"
```

---

## Git Hooks for Automation

### Create Pre-commit Hook
```bash
# Create .git/hooks/pre-commit
#!/bin/bash

# Prevent commits with console.log
if git diff --cached | grep -q 'console.log'; then
    echo "Error: console.log found. Remove before committing."
    exit 1
fi

# Run tests
npm test
if [ $? -ne 0 ]; then
    echo "Error: Tests failed"
    exit 1
fi
```

---

## Advanced Remote Management

```bash
# Add multiple remotes
git remote add origin https://github.com/user/repo.git
git remote add upstream https://github.com/original/repo.git
git remote add backup https://gitlab.com/backup/repo.git

git remote -v           # View all remotes

# Fetch from specific remote
git fetch upstream
git fetch --all

# Push to multiple remotes
git push -u origin main
git push -u backup main

# Set default push location
git branch --set-upstream-to=origin/main main
```

---

## Command Cheatsheet - Complex Operations

```bash
# Find commits not yet merged to main
git log main..feature/current --oneline

# Apply upstream changes safely
git fetch upstream && git merge upstream/main

# Create bug report showing exact changes
git log -p --reverse feature..main -- path/to/file.js

# Monthly commit activity
git shortlog -sn --since="2024-01-01" --until="2024-01-31"

# Who contributes most?
git shortlog -sn

# Commits by hour of day
git log --format=%ai | cut -d' ' -f2 | sort | uniq -c
```

---

## Key Takeaways for Advanced Users
✅ Use `reflog` to recover "lost" commits  
✅ Interactive rebase for history cleanup (local only!)  
✅ `cherry-pick` for selective commits  
✅ Tags for releases and versioning  
✅ Always test rebase/reset behavior locally first  
✅ Use `--dry-run` flags to preview operations  
✅ Document complex workflows for your team  
✅ Remember: Don't rewrite public history unless unavoidable  
