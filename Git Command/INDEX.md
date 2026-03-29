# Git & GitHub Complete Learning Path - Index

Welcome! This comprehensive guide takes you from Git basics to advanced professional workflows. Click on any section to jump to that file.

---

## 📚 Guide Structure

### [1. Git Basics](1_Git_Basics.md) - Start Here!
Perfect for beginners or refreshing fundamentals.

**Topics Covered:**
- Initial setup and configuration
- Creating and cloning repositories
- The basic workflow: add → commit → push
- Understanding what each command does
- Practical scenarios for common tasks

**Key Commands:**
- `git init`, `git clone`, `git status`
- `git add`, `git commit`, `git push`, `git pull`
- `git log`, `git show`

**When You Should Read This:**
- You're completely new to Git
- You want to understand the fundamentals
- You need clear explanations of basic concepts

---

### [2. Git Intermediate](2_Git_Intermediate.md) - Team Collaboration
Learn to work effectively with teams using branches and pull requests.

**Topics Covered:**
- Understanding branches and why they matter
- Creating, switching, merging branches
- Pull requests and code review
- Git Flow and Feature Branch workflows
- Resolving merge conflicts
- Working with multiple features simultaneously
- Syncing and updating branches

**Key Commands:**
- `git branch`, `git checkout`, `git switch`
- `git merge`, `git rebase`
- `git fetch`, `git pull --rebase`
- Conflict resolution techniques

**When You Should Read This:**
- You're working on a team
- You need to understand branching strategies
- You're dealing with merge conflicts
- You want to learn professional workflows

---

### [3. Git Advanced](3_Git_Advanced.md) - Power User Techniques
Master advanced Git operations for complex scenarios.

**Topics Covered:**
- Advanced history inspection and searching
- Interactive rebase and history rewriting
- Stashing and cherry-picking
- Tags and releases
- Advanced merging strategies
- Debugging with Git (blame, bisect, reflog)
- Splitting and combining commits
- Repository optimization
- Git hooks for automation

**Key Commands:**
- `git rebase -i`, `git reset`, `git revert`
- `git stash`, `git cherry-pick`
- `git tag`, `git blame`, `git bisect`
- `git reflog` for recovery

**When You Should Read This:**
- You need to rewrite commit history
- You're debugging a complex issue
- You're maintaining releases
- You want to recover lost work
- You need advanced merging strategies

---

### [4. GitHub Features & Workflows](4_GitHub_Features_Workflows.md) - Real-World Tools
Learn GitHub-specific features and professional development patterns.

**Topics Covered:**
- GitHub authentication and remotes
- Creating and managing pull requests
- GitHub Issues and project management
- Code owners and automated reviews
- GitHub Actions for CI/CD
- Security best practices
- Real-world project scenarios
- Open source contribution workflows
- Disaster recovery techniques
- Team collaboration patterns

**Key Features:**
- Pull Request workflow
- GitHub Issues linking
- Protected branches
- GitHub Actions automation
- GitHub CLI commands
- Forking and upstream workflows

**When You Should Read This:**
- You're using GitHub (or similar)
- You need to set up CI/CD pipelines
- You're managing a team project
- You're contributing to open source
- You need disaster recovery solutions

---

### [5. Command Reference & Quick Guide](5_Command_Reference_Guide.md) - Handy Lookup
A comprehensive reference for quick command lookup and troubleshooting.

**Sections:**
- Quick reference by use case
- Complete command syntax reference
- Common workflows with examples
- Debugging commands table
- Configuration examples
- Common error solutions
- Performance optimization tips
- Useful aliases
- GitHub CLI reference

**Use This For:**
- Looking up command syntax
- Finding the command for your use case
- Troubleshooting errors
- Quick reminders of options
- Setting up useful aliases

---

### [6. Best Practices Guide](6_Best_Practices.md) - Professional Standards
Proven practices for professional Git/GitHub usage and team collaboration.

**Topics Covered:**
- Commit best practices & message formatting
- Branch naming conventions
- Code review standards
- Team workflow patterns
- Security best practices
- Release management
- Documentation and communication
- Performance optimization
- Common anti-patterns to avoid
- Team checklists and guidelines

**Key Areas:**
- Semantic commit messages
- Branch lifecycle management
- Review turnaround standards
- Hotfix and release processes
- Protecting sensitive branches
- Changelog maintenance
- Communication patterns

**When You Should Read This:**
- Leading a team project
- Establishing team standards
- Improving team workflow
- Setting up new projects
- Onboarding new developers
- Want industry best practices

---

### [7. Git Submodules Guide](7_Git_Submodules.md) - Advanced Dependency Management
Complete guide to using Git submodules for managing external code dependencies.

**Topics Covered:**
- What submodules are and how they work
- When to use vs. alternatives
- Creating and adding submodules
- Cloning repos with submodules
- Working within submodules
- Updating and synchronizing submodules
- Removing submodules safely
- Practical workflows and scenarios
- Best practices for team use
- Troubleshooting common issues
- Advanced techniques (branch tracking, monorepo)

**Key Commands:**
- `git submodule add`
- `git clone --recurse-submodules`
- `git submodule update --init --recursive`
- `git submodule update --remote`
- `git submodule deinit/remove`

**When You Should Read This:**
- Managing shared code across projects
- Maintaining forked dependencies
- Building monorepos with independent services
- Complex dependency scenarios
- Need to update or remove submodules
- Team using submodules needs reference

---

### [8. Git by Programming Language](8_Git_By_Programming_Language.md) - Language-Specific Scenarios
Practical Git workflows and `.gitignore` patterns tailored to specific programming languages.

**Languages Covered:**
- **C++** - Build systems (CMake/Make), compilation artifacts
- **C#** - Visual Studio, NuGet packages, .NET ecosystem
- **VB.NET** - Same as C#, different syntax
- **ASP.NET** - Web applications, Entity Framework, database migrations
- **FORTRAN** - Legacy code, compilation, external libraries
- **VBA** - Office macros, module exports, unique tracking

**Each Language Includes:**
- Tailored `.gitignore` patterns
- Project structure recommendations
- Complete workflow scenarios
- Build and test integration
- Dependency management
- Release and deployment

**Key Topics:**
- Language-specific build artifacts to ignore
- Package manager workflows (NuGet, vcpkg, conan)
- CI/CD configuration examples
- Database migration strategies
- Testing frameworks integration
- Version management practices

**When You Should Read This:**
- Working with specific programming languages
- Setting up new projects in these languages
- Understanding `.gitignore` needs per language
- Learning CI/CD for your tech stack
- Onboarding team members to language-specific repos
- Building language-specific workflows

---

## 🎯 Learning Paths by Goal

### "I'm completely new to Git"
1. Start with [Git Basics](1_Git_Basics.md) - **Entire file**
2. Follow the "Basic Commands" section step by step
3. Practice the practical scenarios
4. Keep [Command Reference](5_Command_Reference_Guide.md) handy for lookup

---

### "I need to work with my team"
1. Read [Git Basics](1_Git_Basics.md#basic-commands) - Basic Commands section
2. Read [Git Intermediate](2_Git_Intermediate.md) - **Entire file**
3. Focus on: Branching, Merging, Collaborative Workflows
4. Practice the "Practical Scenarios" section

---

### "I want to master advanced techniques"
1. Complete [Git Basics](1_Git_Basics.md) if you haven't
2. Complete [Git Intermediate](2_Git_Intermediate.md) if you haven't
3. Study [Git Advanced](3_Git_Advanced.md) - **Entire file**
4. Study [Git Submodules](7_Git_Submodules.md) - **If using submodules**
5. Practice the complex scenarios
6. Set up Git hooks and aliases from [Command Reference](5_Command_Reference_Guide.md)
7. Apply best practices from [Best Practices Guide](6_Best_Practices.md)

---

### "I'm managing a GitHub project"
1. Skim [Git Basics](1_Git_Basics.md#basic-commands) for fundamentals
2. Read [Git Intermediate](2_Git_Intermediate.md) for workflows
3. Read [GitHub Features](4_GitHub_Features_Workflows.md) - **Entire file**
4. Read [Best Practices](6_Best_Practices.md) - **Entire file**
5. Focus on: PR workflows, Issues, Protected branches, GitHub Actions, Team standards
6. Use [Command Reference](5_Command_Reference_Guide.md#common-error-solutions) for troubleshooting

---

### "I want to contribute to open source"
1. Read [Git Basics](1_Git_Basics.md) - **Entire file**
2. Read [Git Intermediate](2_Git_Intermediate.md#collaborative-workflows)
3. Read [GitHub Features](4_GitHub_Features_Workflows.md#realistic-project-scenarios) - "Contributing to Open Source" scenario
4. Practice forking and pull request workflows

---

### "I want to learn Git for my specific language/platform"
1. Read [Git Basics](1_Git_Basics.md) - Fundamentals
2. Read [Git Intermediate](2_Git_Intermediate.md) - Branching & collaboration
3. Read [Git by Language](8_Git_By_Programming_Language.md) - **Your specific language section**
4. Follow the workflow scenarios for your language
5. Apply the `.gitignore` patterns shown
6. Set up CI/CD from examples provided

---

## 📋 Quick Command Lookup

**Can't find a command?** Check the [Command Reference Guide](5_Command_Reference_Guide.md)

**Need team standards?** Check the [Best Practices Guide](6_Best_Practices.md)

**Common Quick Lookups:**
- [Staging and Committing](5_Command_Reference_Guide.md#git-add)
- [Checking History](5_Command_Reference_Guide.md#git-log)
- [Managing Branches](5_Command_Reference_Guide.md#git-branch)
- [Fixing Mistakes](5_Command_Reference_Guide.md#undo-operations)
- [Pushing and Pulling](5_Command_Reference_Guide.md#git-push)
- [Common Errors](5_Command_Reference_Guide.md#common-error-solutions)

**Best Practices Quick Lookups:**
- [Commit Message Format](6_Best_Practices.md#1-write-clear-descriptive-commit-messages)
- [Branch Naming Conventions](6_Best_Practices.md#1-branch-naming-conventions)
- [Code Review Standards](6_Best_Practices.md#code-review-practices)
- [Release Process](6_Best_Practices.md#2-release-process)
- [Security Best Practices](6_Best_Practices.md#security-best-practices)

**Language-Specific Lookups:**
- [C++ .gitignore & Workflows](8_Git_By_Programming_Language.md#c)
- [C# NuGet & Visual Studio](8_Git_By_Programming_Language.md#c-1)
- [VB.NET Project Setup](8_Git_By_Programming_Language.md#vbnet)
- [ASP.NET Web Applications](8_Git_By_Programming_Language.md#aspnet)
- [FORTRAN Build Systems](8_Git_By_Programming_Language.md#fortran)
- [VBA Module Management](8_Git_By_Programming_Language.md#vba)

---

## 🔍 Find Solutions by Scenario

### "I need to use submodules"
- **Add submodule:** [Submodules - Creating](7_Git_Submodules.md#creating-submodules)
- **Clone with submodules:** [Submodules - Cloning](7_Git_Submodules.md#cloning-repositories-with-submodules)
- **Update submodules:** [Submodules - Updating](7_Git_Submodules.md#updating-submodules)
- **Remove submodule:** [Submodules - Removing](7_Git_Submodules.md#removing-submodules)
- **Troubleshooting:** [Submodules - Troubleshooting](7_Git_Submodules.md#troubleshooting)

### "I'm working with [specific programming language]"
- **C++:** [Git for C++](8_Git_By_Programming_Language.md#c) - CMake, build artifacts, vcpkg
- **C#:** [Git for C#](8_Git_By_Programming_Language.md#c-1) - NuGet, Visual Studio, testing
- **VB.NET:** [Git for VB.NET](8_Git_By_Programming_Language.md#vbnet) - Language-specific patterns
- **ASP.NET:** [Git for ASP.NET](8_Git_By_Programming_Language.md#aspnet) - Web apps, EF Core, databases
- **FORTRAN:** [Git for FORTRAN](8_Git_By_Programming_Language.md#fortran) - Legacy code, compilation
- **VBA:** [Git for VBA](8_Git_By_Programming_Language.md#vba) - Office macros, module tracking

### "I made a mistake"
- **Uncommitted changes:** [Basic Commands - Undo](1_Git_Basics.md#scenario-3-fixing-a-mistake-in-current-work)
- **Wrong last commit:** [Basic Commands - Fix Last Commit](1_Git_Basics.md#6-commit-changes)
- **Already pushed:** [Advanced - Revert](3_Git_Advanced.md#4-revert-undo-safely-on-public-branches)
- **Recovery:** [Advanced - Reflog](3_Git_Advanced.md#3-reflog---recovery-tool)

### "I'm working with branches"
- **Create branch:** [Intermediate - Branching](2_Git_Intermediate.md#branching-commands)
- **Merge conflict:** [Intermediate - Merge Conflicts](2_Git_Intermediate.md#scenario-2-resolving-merge-conflicts)
- **Keep updated:** [Intermediate - Syncing](2_Git_Intermediate.md#scenario-1-team-member-updates-your-feature-branch)

### "I'm managing a release"
- **Tag version:** [Advanced - Tags](3_Git_Advanced.md#tags-and-releases)
- **Release workflow:** [GitHub - Workflows](4_GitHub_Features_Workflows.md#scenario-1-team-project-with-release-cycle)
- **Fix in production:** [GitHub - Hotfix](4_GitHub_Features_Workflows.md#scenario-3-hotfix-for-production-issue)

### "I need code review"
- **Create PR:** [GitHub Features - PR Workflow](4_GitHub_Features_Workflows.md#1-creating-a-pull-request-from-cli)
- **Review PR:** [GitHub Features - Code Review](4_GitHub_Features_Workflows.md#1-code-review-process)
- **Merge PR:** [GitHub Features - Merge PR](4_GitHub_Features_Workflows.md#1-creating-a-pull-request-from-cli)

---

## 🛠️ Tools & Setup

### Initial Setup
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```
See [Git Basics - Initial Setup](1_Git_Basics.md#initial-setup)

### GitHub CLI Installation
```bash
brew install gh          # macOS
choco install gh         # Windows
apt install gh           # Linux
gh auth login            # Login
```
See [GitHub Features - GitHub CLI](4_GitHub_Features_Workflows.md#1-creating-a-pull-request-from-cli)

### Useful Aliases
```bash
git config --global alias.st status
git config --global alias.lg "log --graph --oneline --all"
git config --global alias.amend "commit --amend --no-edit"
```
See [Command Reference - Aliases](5_Command_Reference_Guide.md#useful-aliases-to-add)

---

## 📈 Progress Tracking

### Beginner (Estimated 2-3 hours)
- [ ] Read [Git Basics](1_Git_Basics.md)
- [ ] Practice basic workflow: init → add → commit → push → pull
- [ ] Understand each command's purpose

### Intermediate (Estimated 3-4 hours)
- [ ] Read [Git Intermediate](2_Git_Intermediate.md)
- [ ] Practice creating and merging branches
- [ ] Resolve merge conflicts
- [ ] Create pull requests

### Advanced (Estimated 4-5 hours)
- [ ] Read [Git Advanced](3_Git_Advanced.md)
- [ ] Learn history rewriting and debugging
- [ ] Practice complex scenarios
- [ ] Understand Git internals

### Professional (Ongoing)
- [ ] Read [GitHub Features](4_GitHub_Features_Workflows.md)
- [ ] Read [Best Practices](6_Best_Practices.md)
- [ ] Set up CI/CD with GitHub Actions
- [ ] Implement team workflows
- [ ] Lead code reviews
- [ ] Reference [Command Guide](5_Command_Reference_Guide.md) regularly
- [ ] Establish team standards from [Best Practices](6_Best_Practices.md)

---

## 🎓 Key Concepts Summary

### Git Fundamentals
1. **Repository** - Stores all version history in `.git` folder
2. **Commits** - Snapshots of your changes
3. **Branches** - Parallel lines of development
4. **Staging** - Selecting which changes to commit
5. **Remote** - Connection to GitHub (or similar)

### Workflow
```
Working Directory
    ↓ (git add)
Staging Area
    ↓ (git commit)
Local Repository
    ↓ (git push)
Remote Repository (GitHub)
```

### Branching Strategy
```
main (always production-ready)
├── feature/x (new features)
├── bugfix/y (bug fixes)
├── release/z (release prep)
└── hotfix/w (production fixes)
```

---

## 🔗 External Resources

- **[Official Git Docs](https://git-scm.com/doc)** - Authoritative reference
- **[GitHub Docs](https://docs.github.com)** - GitHub-specific help
- **[Atlassian Tutorials](https://www.atlassian.com/git/tutorials)** - In-depth explanations
- **[Oh My Git](https://ohmygit.org)** - Interactive learning game
- **[Git Cheat Sheet](https://github.github.com/training-kit/downloads/github-git-cheat-sheet.pdf)** - Downloadable reference

---

## ❓ FAQ

**Q: How often should I commit?**  
A: Several times per day. Commit logically grouped changes. See [Git Basics - Commit](1_Git_Basics.md#6-commit-changes)

**Q: When should I use rebase vs merge?**  
A: Merge for shared branches, rebase for solo work. See [Git Intermediate - Rebase vs Merge](2_Git_Intermediate.md#2-rebase-alternative-to-merge)

**Q: Can I undo a pushed commit?**  
A: Use `git revert` for public branches. See [Advanced - Revert](3_Git_Advanced.md#4-revert-undo-safely-on-public-branches)

**Q: How do I recover a deleted branch?**  
A: Use `git reflog` to find and restore. See [Advanced - Reflog](3_Git_Advanced.md#3-reflog---recovery-tool)

**Q: What's a good commit message?**  
A: Clear, describes the "why" not just "what". Use semantic format. See [Best Practices - Commit Messages](6_Best_Practices.md#1-write-clear-descriptive-commit-messages)

**Q: How do I handle merge conflicts?**  
A: Edit file, resolve conflicts, stage, and commit. See [Intermediate - Merge Conflicts](2_Git_Intermediate.md#scenario-2-resolving-merge-conflicts)

**Q: What should I include in a PR description?**  
A: Problem, solution, testing details, and related links. See [Best Practices - PR Descriptions](6_Best_Practices.md#3-pr-descriptions)

**Q: How do I name branches?**  
A: Use pattern `<type>/<description>` with lowercase and hyphens. See [Best Practices - Branch Naming](6_Best_Practices.md#1-branch-naming-conventions)

---

## 📞 Need Help?

1. **Command not working?** → Check [Command Reference](5_Command_Reference_Guide.md#common-error-solutions)
2. **"How do I...?"** → Check [Quick Lookup by Topic](#-quick-command-lookup)
3. **Learning concept?** → Read relevant guide file
4. **Real scenario?** → Check "Practical Scenarios" section in each guide

---

## ✨ Tips for Success

1. **Practice Regularly** - Git fluency comes through repetition
2. **Use Meaningful Names** - For branches, commits, and tags
3. **Review Before Pushing** - Use `git diff` to catch mistakes
4. **Commit Often** - Smaller commits are easier to understand and fix
5. **Read git log** - Understanding history prevents mistakes
6. **Backup** - Remote repository (GitHub) is your backup
7. **Learn from Others** - Review teammates' commits and PRs
8. **Use Aliases** - Speed up common commands

---

**Ready to start? Begin with [Git Basics](1_Git_Basics.md) or jump to your learning path above.**

Last Updated: 2024
