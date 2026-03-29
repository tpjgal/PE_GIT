# Git Command Reference & Quick Guide

## Quick Reference by Use Case

### Starting Out
```bash
git init                              # Create new repo
git clone <url>                       # Copy existing repo
git config user.name "Name"           # Set your name
git config user.email "email"         # Set your email
```

### Daily Workflow
```bash
git status                            # See what changed
git add .                             # Stage changes
git commit -m "message"               # Save changes
git push                              # Upload to GitHub
git pull                              # Download latest
```

### Creating Branches
```bash
git branch feature-name               # Create branch
git checkout branch-name              # Switch to branch
git checkout -b new-branch            # Create and switch
git branch -d old-branch              # Delete branch
```

### Fixing Mistakes
```bash
git checkout -- file.js               # Undo changes to file
git reset HEAD~1                      # Undo last commit
git revert abc1234                    # Undo commit (safe)
git stash                             # Save work temporarily
```

### Merging & Collaboration
```bash
git merge branch-name                 # Combine branches
git rebase main                       # Replay commits
git cherry-pick abc1234               # Apply specific commit
git pull --rebase                     # Pull with rebase
```

---

## Command Syntax Reference

### git add
```
git add <files>              # Stage specific files
git add .                    # Stage all changes
git add *.js                 # Stage by pattern
git add -A                   # Stage all in repo
git add -p                   # Interactive staging (choose parts)
```

### git commit
```
git commit -m "message"          # Commit with message
git commit -am "message"         # Stage + commit tracked files
git commit --amend               # Modify last commit
git commit --amend --no-edit     # Add changes to last commit
git commit --allow-empty -m ""   # Create empty commit
```

### git log
```
git log                      # All commits
git log --oneline            # Short format
git log -n 10                # Last 10
git log --author="Name"      # Filter by author
git log --since="2 weeks"    # Time range
git log -p                   # Show changes
git log --graph --all        # Branch visualization
git log file.js              # Commits affecting file
git log -S "search"          # Search content
git log --follow file.js     # History including renames
```

### git diff
```
git diff                     # Unstaged changes
git diff --staged            # Staged changes
git diff main                # Changes vs main
git diff abc1234 def5678     # Between commits
git diff HEAD~2 HEAD         # Last 2 commits
git diff file.js             # Changes to specific file
```

### git branch
```
git branch                   # List local branches
git branch -a                # List all (local + remote)
git branch new-name          # Create branch
git branch -d name           # Delete branch
git branch -m old new        # Rename branch
git branch -v                # Show last commit
git branch --merged          # Show merged branches
git branch --no-merged       # Show unmerged branches
git branch -c old new        # Copy branch (Git 2.28+)
```

### git checkout / git switch
```
git checkout branch-name     # Switch to branch
git checkout -b new-branch   # Create and switch
git checkout abc1234         # Go to commit (detached HEAD)
git checkout file.js         # Discard changes to file

# Newer syntax:
git switch branch-name       # Switch to branch
git switch -c new-branch     # Create and switch
```

### git reset
```
git reset file.js            # Unstage file
git reset HEAD~1             # Undo last commit (keep changes)
git reset --soft HEAD~1      # Undo, keep staged
git reset --hard HEAD~1      # Undo, discard changes
git reset --hard abc1234     # Go to specific commit
```

### git revert
```
git revert abc1234           # Create new commit undoing changes
git revert HEAD~1            # Undo previous commit
git revert -n abc1234        # Revert without committing yet
git revert abc1234..def5678  # Revert range
```

### git merge
```
git merge branch-name        # Merge branch into current
git merge --no-ff name       # Force merge commit
git merge --squash name      # Squash commits
git merge -X theirs name     # Conflict resolution strategy
```

### git rebase
```
git rebase branch-name       # Rebase onto branch
git rebase -i HEAD~3         # Interactive rebase (last 3)
git rebase --continue        # Resume after conflict fix
git rebase --abort           # Cancel rebase
```

### git push
```
git push                     # Push current branch
git push origin branch       # Push specific branch
git push origin main         # Push to specific remote
git push -u origin branch    # Set upstream
git push --all               # Push all branches
git push origin --tags       # Push tags
git push origin --delete branch  # Delete remote branch
git push --force             # Force push (use carefully!)
```

### git pull
```
git pull                     # Fetch + merge
git pull origin main         # From specific remote/branch
git pull --rebase            # Fetch + rebase
git pull --no-rebase         # Explicit merge (default)
```

### git fetch
```
git fetch                    # Get updates (no merge)
git fetch origin             # From specific remote
git fetch --all              # From all remotes
git fetch -p                 # Prune stale branches
```

### git stash
```
git stash                    # Save current work
git stash save "message"     # Save with description
git stash list               # Show all stashes
git stash show stash@{0}     # Show what's in stash
git stash pop                # Apply and remove stash
git stash apply              # Apply without removing
git stash drop stash@{0}     # Delete stash
git stash clear              # Delete all stashes
```

### git tag
```
git tag v1.0.0               # Create lightweight tag
git tag -a v1.0.0 -m "msg"   # Create annotated tag
git tag -d tag-name          # Delete local tag
git push origin v1.0.0        # Push specific tag
git push origin --tags        # Push all tags
git show v1.0.0              # Show tag details
```

### git cherry-pick
```
git cherry-pick abc1234      # Apply commit
git cherry-pick abc1234..def5678  # Range of commits
git cherry-pick --continue   # Resume after conflict
git cherry-pick --abort      # Cancel cherry-pick
```

---

## Workflow Quick Reference

### Standard Workflow
```bash
# 1. Start
git checkout -b feature/x

# 2. Work
git add .
git commit -m "..."

# 3. Ready to push
git push -u origin feature/x

# 4. Create PR on GitHub

# 5. After merge
git checkout main
git pull
git branch -d feature/x
```

### Sync with Team
```bash
# Get latest
git pull

# Or with rebase
git pull --rebase

# Sync feature branch with main
git fetch origin
git rebase origin/main
```

### Undo Operations

| Situation | Command | Effect |
|-----------|---------|--------|
| Undo unstaged changes | `git checkout -- file` | Discards changes |
| Undo staged changes | `git reset HEAD file` | Moves to unstaged |
| Undo last commit (local) | `git reset --soft HEAD~1` | Keeps changes staged |
| Undo commit (on main) | `git revert abc1234` | Creates new commit |
| Remove files from tracking | `git rm --cached file` | Keeps local copy |
| Restore deleted file | `git checkout HEAD~1 file` | Gets from history |

---

## Common Multi-Step Workflows

### Fix Before Pushing
```bash
# Forgot a file in last commit
git add forgotten-file.js
git commit --amend --no-edit
git push

# Or wrong commit message
git commit --amend -m "Correct message"
git push --force-with-lease # Safer than --force
```

### Clean Up Commits Before Pushing
```bash
git rebase -i origin/main
# Pick/squash/reword commits
git push
```

### Combine Multiple Branches
```bash
# Start with feature1
git checkout -b combine-features

# Get feature2 changes
git merge feature2
# Fix conflicts if any

# Get feature3 changes
git merge feature3

# Now combined has all changes
git push origin combine-features
```

### Backport Fix to Older Version
```bash
# Current main has critical fix
git log --oneline | grep "critical fix"

# Get hash of that commit
git checkout -b hotfix-v1.2 v1.2-tag

git cherry-pick abc1234
git tag v1.2.1
git push origin v1.2.1
```

---

## Debugging Commands

| Task | Command |
|------|---------|
| Who changed line X? | `git blame file.js` |
| When was this deleted? | `git log --diff-filter=D file` |
| Find commits with word | `git log -S "word"` |
| Find by message | `git log --grep="pattern"` |
| Show file at commit | `git show abc1234:file.js` |
| Compare branches | `git diff main feature` |
| Show merge conflicts | `git diff --check` |

---

## Configuration Reference

```bash
# See all config
git config --list

# User info
git config user.name "Name"
git config user.email "email@example.com"

# Default branch naming
git config --global init.defaultBranch main

# Default editor
git config core.editor "vim"

# Alias examples
git config alias.st status
git config alias.co checkout
git config alias.br branch
git config alias.cm "commit -m"
git config alias.lg "log --graph --oneline --all"

# Use aliases
git st              # Same as git status
git co branch       # Same as git checkout branch
git cm "message"    # Same as git commit -m "message"
```

---

## Common Error Solutions

### "fatal: Not a git repository"
```bash
# You're not in a Git repo
git init                    # Create one, or
cd /path/to/existing/repo   # Go to existing one
```

### "Your branch is ahead of 'origin/main'"
```bash
# Local has commits not pushed
git push                    # Push them
```

### "nothing to commit, working tree clean"
```bash
# All changes already staged and committed
# No uncommitted work
```

### "CONFLICT (content merge conflict)"
```bash
# Edit conflicted files manually
# Remove conflict markers
# git add resolved-files
# git commit
# (or git rebase --continue for rebase)
```

### "detached HEAD"
```bash
# You're on a commit, not a branch
# Create a branch to save work
git branch my-work
git checkout my-work

# Or go back to main
git checkout main
```

### "fatal: refusing to merge unrelated histories"
```bash
# When merging repos with different histories
git merge --allow-unrelated-histories branch
```

### "Permission denied (publickey)"
```bash
# SSH key issue
# Check key added to GitHub
# Verify connection: ssh -T git@github.com
# Or use HTTPS instead of SSH
```

---

## Performance Tips

```bash
# Shallow clone for large repos
git clone --depth 1 <url>

# Later, get full history
git fetch --unshallow

# Remove unnecessary files
git gc --aggressive

# Check repo size
du -sh .git

# Remove untracked files
git clean -fd
```

---

## Useful Aliases to Add

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm "commit -m"
git config --global alias.amend "commit --amend --no-edit"
git config --global alias.undo "reset --soft HEAD~1"
git config --global alias.lg "log --graph --oneline --all --decorate"
git config --global alias.changes "diff --name-status"
git config --global alias.unstage "reset HEAD"
git config --global alias.latest "log -1 HEAD"
git config --global alias.contrib "shortlog --summary --numbered"
```

---

## GitHub CLI Quick Reference

```bash
# Install: brew install gh (or choco install gh on Windows)

# Auth
gh auth login

# Issues
gh issue create --title "Bug: X" --body "Description"
gh issue list
gh issue view 123
gh issue close 123

# Pull Requests
gh pr create --title "Feature X"
gh pr list --state open
gh pr checkout 123           # Pull PR locally
gh pr review 123 --approve
gh pr merge 123 --squash

# Releases
gh release create v1.0.0
gh release upload v1.0.0 file.zip

# Repos
gh repo create my-project --public
gh repo view --web          # Open in browser
```

---

## Best Practices Checklist

✅ **Commits**
- [ ] Write clear, descriptive messages
- [ ] Commit logically related changes together
- [ ] Don't commit commented-out code
- [ ] Don't hardcode secrets/API keys

✅ **Branches**
- [ ] Use descriptive branch names
- [ ] Delete merged branches
- [ ] Keep feature branches focused
- [ ] Update from main before pushing

✅ **Push/Pull**
- [ ] Pull before starting work
- [ ] Push frequently (daily minimum)
- [ ] Review changes before pushing
- [ ] Don't force-push to shared branches

✅ **Collaboration**
- [ ] Use pull requests for code review
- [ ] Respond to review feedback promptly
- [ ] Communicate about large changes
- [ ] Help resolve conflicts

✅ **Security**
- [ ] Use SSH keys or tokens (not passwords)
- [ ] Don't commit .env or secrets
- [ ] Use private repos for sensitive code
- [ ] Validate who has access

---

## Resources

- [Git Official Documentation](https://git-scm.com/doc)
- [GitHub Docs](https://docs.github.com)
- [Atlassian Git Tutorials](https://www.atlassian.com/git)
- [Oh My Git! Interactive Learning](https://ohmygit.org)
- [Git Cheat Sheet](https://github.github.com/training-kit/downloads/github-git-cheat-sheet.pdf)

---

## Terminal Tips

```bash
# Pretty branch graph
git log --graph --oneline --all

# See what you did
git reflog

# Check status quickly
git status -s

# Dry run (preview changes)
git push --dry-run

# Staging hunks interactively
git add -p

# View staged changes before commit
git diff --staged
```

---

Remember: When in doubt, `git status` and `git log --oneline` are your friends!
