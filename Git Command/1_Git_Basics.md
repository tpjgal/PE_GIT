# Git Basics - From Beginner to Advanced

## Table of Contents
1. [Initial Setup](#initial-setup)
2. [Basic Commands](#basic-commands)
3. [Understanding Git Workflow](#understanding-git-workflow)
4. [Practical Scenarios](#practical-scenarios)

---

## Initial Setup

### Configure Your Identity
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# View current configuration
git config --list
```

**Explanation:** Git needs to know who you are when you make commits. `--global` applies settings to all repositories on your machine. Use `--local` for project-specific settings.

---

## Basic Commands

### 1. Initialize a Repository
```bash
git init                    # Create a new Git repository in current directory
git init my-project         # Create a new directory with Git initialized
```

**Explanation:** This creates a `.git` folder that tracks all version history. Every project needs this before you can start version control.

---

### 2. Clone a Repository
```bash
git clone <url>                              # Clone into a folder with repo name
git clone <url> my-local-folder              # Clone into specific folder
git clone -b branch-name <url>              # Clone specific branch
git clone --depth 1 <url>                   # Shallow clone (faster, less history)
```

**Explanation:** Downloading an existing repository from GitHub or other remote sources. `--depth 1` is useful for large projects when you only need recent history.

**Scenario:** Your team started a project on GitHub. You need to work on it locally:
```bash
git clone https://github.com/company/project.git
cd project
```

---

### 3. Check Status
```bash
git status                  # Show current status of working directory
git status -s              # Short format
```

**Explanation:** Shows which files are modified, staged, or untracked. Always run this before committing to know what changes you're about to save.

**Output Example:**
```
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to stage)
        modified:   app.js
        
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        config.json
```

---

### 4. Stage Changes
```bash
git add file.js             # Stage specific file
git add *.js               # Stage all .js files
git add .                  # Stage all changes in current directory
git add -A                 # Stage all changes in entire repository
```

**Explanation:** "Staging" means marking files to be included in the next commit. This gives you control over what gets saved together.

**Scenario - Partial Commit:**
You fixed 2 bugs, but only want to commit one:
```bash
git status  # See both modified files
git add bug-fix-1.js  # Only stage the first fix
git commit -m "Fix: Address null reference error"
# bug-fix-2.js remains uncommitted for later
```

---

### 5. View Staged Changes
```bash
git diff                   # Show unstaged changes
git diff --staged          # Show staged changes (what will be committed)
git diff HEAD             # Show all changes since last commit
```

**Explanation:** Lets you review exactly what's changing before committing. This helps catch mistakes.

---

### 6. Commit Changes
```bash
git commit -m "Your message"              # Commit with message
git commit -am "message"                  # Stage tracked files and commit
git commit --amend -m "New message"       # Fix last commit message
git commit --amend --no-edit              # Add changes to last commit without changing message
```

**Explanation:** Creates a snapshot of your staged changes. A good commit message explains the "why", not just the "what".

**Scenario - Good vs Bad Commit Messages:**
```bash
# ❌ Bad
git commit -m "fixed stuff"
git commit -m "changes"

# ✅ Good
git commit -m "Add authentication error handling for login failures"
git commit -m "Refactor database connection pooling for performance"
```

---

### 7. View Commit History
```bash
git log                        # View last commits (newest first)
git log --oneline             # Condensed view with hashes
git log -n 5                  # Show last 5 commits
git log --author="Name"       # Filter by author
git log --since="2 weeks ago" # Show commits from recent time period
git log -p                    # Show full diff for each commit
git log --graph --oneline --all  # Visual branch graph
```

**Explanation:** Review what has been saved and by whom. Helps track project history.

**Example Output:**
```
abc1234 Add user profile feature
def5678 Fix login validation bug
ghi9012 Update dependencies
```

---

### 8. View Specific Commit
```bash
git show abc1234             # Show specific commit details and diff
git show abc1234:file.js     # View file as it was in that commit
```

**Explanation:** See exactly what changed in any commit and understand the reasoning.

---

### 9. Push to Remote
```bash
git push                     # Push current branch to remote
git push origin main         # Push main branch to origin remote
git push -u origin branch-name  # Set upstream tracking and push
git push --all               # Push all branches
git push origin --tags       # Push all tags
```

**Explanation:** Upload your local commits to GitHub (or other remote repository). This backs up your work and shares it with team members.

**Scenario - First Push:**
```bash
git push -u origin main
# -u sets this branch to track origin/main
# Future pushes on main just need: git push
```

---

### 10. Pull from Remote
```bash
git pull                     # Fetch and merge latest changes
git pull origin main         # Pull from specific branch
git pull --rebase            # Fetch and rebase instead of merge
```

**Explanation:** Get the latest changes from teammates. This keeps your local code synchronized with the remote repository.

**Scenario - Team Collaboration:**
```bash
# Team member 1 pushes new feature
# You run git pull to get their changes
git pull
# Now your code has their feature, you can build on it
```

---

## Understanding Git Workflow

### The Basic Workflow
```
Working Directory → Staging Area → Repository (Local) → Remote (GitHub)
                     (git add)      (git commit)        (git push)
```

### Step-by-Step Example
```bash
# 1. Make changes to files (in working directory)
# Edit app.js, index.html

# 2. Check what changed
git status

# 3. Stage the changes
git add app.js index.html

# 4. Verify staging
git status

# 5. Commit to local repository
git commit -m "Update UI and styling"

# 6. Push to remote (GitHub)
git push
```

---

## Practical Scenarios

### Scenario 1: Starting a New Project
```bash
# Create project directory
mkdir my-app
cd my-app

# Initialize Git
git init

# Create initial files
echo "# My App" > README.md
echo "console.log('Hello');" > app.js

# Add and commit
git add .
git commit -m "Initial project setup"

# Create repository on GitHub, then connect it
git remote add origin https://github.com/username/my-app.git
git branch -M main
git push -u origin main
```

---

### Scenario 2: Contributing to an Existing Project
```bash
# 1. Clone the repository
git clone https://github.com/company/project.git
cd project

# 2. Create a new branch for your work
git checkout -b feature/add-search

# 3. Make your changes and commit
git add .
git commit -m "Add search functionality"

# 4. Push your branch
git push -u origin feature/add-search

# 5. Create a Pull Request on GitHub
# (This is done through GitHub interface)
```

---

### Scenario 3: Fixing a Mistake in Current Work
```bash
# Made changes you want to discard
git status

# Option 1: Discard unstaged changes
git checkout file.js

# Option 2: Discard all changes
git checkout .

# Option 3: Stash changes (save for later)
git stash
# Later: git stash pop
```

---

### Scenario 4: Undoing the Last Commit (Not Pushed)
```bash
# Fix mistake before pushing
git reset HEAD~1

# This undoes the commit but keeps your changes staged
git status  # Files are ready to be recommitted with fix

# Now recommit with fix
git commit -m "Fixed: Correct calculation method"
```

---

## Key Takeaways
✅ Always run `git status` before committing  
✅ Write clear, descriptive commit messages  
✅ Commit frequently with logical groupings  
✅ Push regularly to back up your work  
✅ Pull before starting work to get team changes  
