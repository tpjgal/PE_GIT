# GitHub Actions Learning Path

## Your Step-by-Step Learning Journey

This document outlines your complete path to mastering GitHub Actions, from absolute beginner to proficient user.

---

## 📚 Module Overview

| # | Lesson | Duration | Difficulty | What You'll Learn |
|---|--------|----------|------------|-------------------|
| 1 | Core Concepts | 20 min | ⭐ Beginner | Fundamentals of GitHub Actions |
| 2 | Workflow Anatomy | 30 min | ⭐ Beginner | Structure and syntax |
| 3 | Triggers & Events | 25 min | ⭐⭐ Easy | When workflows run |
| 4 | Jobs & Steps | 35 min | ⭐⭐ Easy | Job execution and ordering |
| 5 | Actions & Marketplace | 30 min | ⭐⭐ Easy | Using reusable components |
| 6 | Practical Examples | 40 min | ⭐⭐ Easy | Real-world workflows |
| 7 | Best Practices | 30 min | ⭐⭐⭐ Intermediate | Optimization and security |

**Total Time: ~3.5 hours** (Reading + Hands-On Practice)

---

## 🎯 Learning Timeline

### Day 1: Foundations (1 hour)

**Time: 9:00 - 10:00 AM**

```
09:00 - 09:20  Read: Lesson 1 - Core Concepts
09:20 - 09:40  Read: Lesson 2 - Workflow Anatomy (first section)
09:40 - 10:00  HANDS-ON: Create hello-world.yml
               → Try first workflow in your repository
```

**Deliverable:** Your first working GitHub Actions workflow

**How to verify:** 
- Go to your repository
- Click "Actions" tab
- See your workflow run and succeed

---

### Day 1: Triggers (30 minutes)

**Time: 10:00 - 10:30 AM**

```
10:00 - 10:15  Read: Lesson 3 - Triggers & Events (sections 3.1-3.3)
10:15 - 10:30  HANDS-ON: Create multiple-triggers.yml
               → Try push, pull_request, and workflow_dispatch triggers
```

**Deliverable:** Workflow that triggers on multiple events

**How to verify:**
- Make a commit → Workflow runs automatically
- Create a PR → See it in PR checks
- Manual trigger → Use Actions tab → "Run workflow"

---

### Day 1: Jobs & Steps (40 minutes)

**Time: 10:30 - 11:10 AM**

```
10:30 - 10:50  Read: Lesson 4 - Jobs & Steps (sections 4.1-4.5)
10:50 - 11:10  HANDS-ON: Create sequential-jobs.yml
               → Practice job dependencies and matrix builds
```

**Deliverable:** Workflow with dependent jobs and matrix strategy

**How to verify:**
- Check Actions tab
- See jobs running sequentially not in parallel
- Matrix creates multiple jobs (2x3=6 jobs)

---

### Day 2: Actions (30 minutes)

**Time: 14:00 - 14:30**

```
14:00 - 14:15  Read: Lesson 5 - Actions & Marketplace (sections 5.1-5.5)
14:15 - 14:30  HANDS-ON: build-and-test.yml
               → Use official GitHub actions for setup and caching
```

**Deliverable:** Workflow with multiple actions from marketplace

**How to verify:**
- Workflow completes successfully
- Dependencies are cached (second run is faster)
- See action names in workflow steps

---

### Day 2: Real-World Workflows (40 minutes)

**Time: 14:30 - 15:10**

```
14:30 - 15:05  Read: Lesson 6 - Practical Examples (choose your tech stack)
15:05 - 15:10  HANDS-ON: Adapt example to your project
               → Customize for your repository's languages/tools
```

**Deliverable:** Production-ready workflow for your project

**How to verify:**
- All tests pass
- Build artifact is created
- Workflow completes without errors

---

### Day 2: Optimization (30 minutes)

**Time: 15:10 - 15:40**

```
15:10 - 15:40  Read: Lesson 7 - Best Practices (sections 7.1-7.4)
               HANDS-ON: Optimize your workflow
               → Add caching, use matrix intelligently, add timeouts
```

**Deliverable:** Optimized workflow that runs faster

**How to verify:**
- First run: baseline execution time (note it)
- Second run: should be faster due to caching
- Check workflow execution times in Actions tab

---

## 🎓 Progressive Exercises

### Level 1: Beginner (After Lesson 2)

**Exercise 1.1: Hello World** ✅
- Location: `examples/hello-world.yml`
- Copy to your `.github/workflows/`
- Push and verify it runs

**Exercise 1.2: Environment Variables**
```yaml
name: Env Variables

on: push

env:
  MESSAGE: "Hello GitHub Actions"

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: echo ${{ env.MESSAGE }}
      - run: echo "Repository: ${{ github.repository }}"
```

**Exercise 1.3: Step Names**
```yaml
steps:
  - name: First step
    run: echo "Step 1"
  
  - name: Second step
    run: echo "Step 2"
```

---

### Level 2: Easy (After Lesson 4)

**Exercise 2.1: Sequential Jobs**
- Location: `examples/sequential-jobs.yml` (referenced in Lesson 4)
- Modify to add a fourth job
- Verify they run in order

**Exercise 2.2: Conditional Execution**
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building..."
  
  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying only on main"
```

**Exercise 2.3: Matrix Build**
```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest]
    node: [18, 20]
```

---

### Level 3: Intermediate (After Lesson 5)

**Exercise 3.1: Use Multiple Actions**
```yaml
- uses: actions/checkout@v3
- uses: actions/setup-node@v3
  with:
    node-version: 18
    cache: npm
- uses: actions/upload-artifact@v3
  with:
    name: dist
    path: dist/
```

**Exercise 3.2: Get Action Outputs**
```yaml
- uses: some-action/build@v1
  id: build

- run: echo "Output: ${{ steps.build.outputs.result }}"
```

**Exercise 3.3: GitHub Actions Marketplace**
- Visit https://github.com/marketplace?type=actions
- Find 3 actions relevant to your project
- Read their documentation
- Add one to your workflow

---

### Level 4: Advanced (After Lesson 6)

**Exercise 4.1: Deploy Pipeline**
- Location: `examples/deployment.yml`
- Adapt to your deployment target
- Set up staging and production environments

**Exercise 4.2: Full CI/CD Workflow**
```yaml
on: push

jobs:
  lint:
    runs-on: ubuntu-latest
    steps: []
  
  test:
    needs: lint
    runs-on: ubuntu-latest
    steps: []
  
  build:
    needs: test
    runs-on: ubuntu-latest
    steps: []
  
  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps: []
```

**Exercise 4.3: Matrix Testing**
```yaml
strategy:
  matrix:
    node: [16, 18, 20]
    os: [ubuntu-latest, windows-latest]
  include:
    - node: 18
      experimental: true
```

---

### Level 5: Expert (After Lesson 7)

**Exercise 5.1: Performance Optimization**
- Enable caching
- Configure matrix efficiently
- Add timeouts
- Run before/after: compare execution time

**Exercise 5.2: Security Hardening**
- Use secrets for API keys
- Limit permissions
- Pin action versions
- Run security scanning

**Exercise 5.3: Custom Action (Composite)**
Create `.github/actions/my-action/action.yml`:
```yaml
name: My Custom Action
description: Does something useful

inputs:
  input1:
    description: First input
    required: true

outputs:
  output1:
    description: First output
    value: ${{ steps.step1.outputs.value }}

runs:
  using: composite
  steps:
    - run: echo "Input: ${{ inputs.input1 }}"
```

---

## 📈 Progress Tracking

### After Lesson 1 ✓
- [ ] Understand what GitHub Actions is
- [ ] Know the four pillars (workflows, triggers, jobs, actions)
- [ ] Understand runners and artifacts

### After Lesson 2 ✓
- [ ] Can read YAML syntax
- [ ] Understand workflow file structure
- [ ] Know what each section does
- [ ] Start your first workflow with Actions tab

### After Lesson 3 ✓
- [ ] Can configure different triggers
- [ ] Understand cron syntax
- [ ] Can write conditional triggers
- [ ] Test on push, PR, and schedule

### After Lesson 4 ✓
- [ ] Control job execution order
- [ ] Use matrix for multiple configurations
- [ ] Make steps conditional
- [ ] Share data between jobs/steps

### After Lesson 5 ✓
- [ ] Use actions from marketplace
- [ ] Understand action inputs/outputs
- [ ] Create custom composite actions
- [ ] Build reusable components

### After Lesson 6 ✓
- [ ] Build production-ready workflows
- [ ] Deploy applications
- [ ] Run automated tests
- [ ] Adapt examples to your tech stack

### After Lesson 7 ✓
- [ ] Optimize for performance
- [ ] Implement security best practices
- [ ] Troubleshoot common issues
- [ ] Write maintainable workflows

---

## 🚀 Recommended Next Steps

### Immediate (Next 24 hours)
1. ✅ Complete Lessons 1-2
2. ✅ Create your first workflow
3. ✅ Test multiple triggers

### This Week
1. ✅ Complete Lessons 3-5
2. ✅ Build testing workflow
3. ✅ Implement caching
4. ✅ Add deployment job

### Next Week
1. ✅ Complete Lessons 6-7
2. ✅ Optimize workflow performance
3. ✅ Set up security scanning
4. ✅ Create team documentation

### Ongoing
1. 📚 Read official documentation
2. 📝 Join GitHub Community
3. 🔍 Review other projects' workflows
4. 💡 Contribute to open source with CI/CD

---

## 📞 Getting Help

### When stuck on:

**Basic Syntax Errors**
- Check YAML indentation (2 spaces!)
- Use GitHub's web editor (validates automatically)
- Install actionlint locally

**Workflow Not Triggering**
- Verify file is in `.github/workflows/`
- Check branch name matches
- Verify `on:` syntax

**Actions Not Found**
- Use exact format: `owner/repo@version`
- Check marketplace documentation
- Pin to specific version

**Permission Issues**
- Check `permissions:` section
- Verify secrets exist
- Check runner has necessary access

**Performance Problems**
- Enable caching
- Reduce matrix combinations
- Check log output for bottlenecks

---

## 📚 Additional Resources

### Official Documentation
- [GitHub Actions Docs](https://docs.github.com/actions)
- [Workflow Syntax](https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions)
- [Context & Expression Reference](https://docs.github.com/actions/learn-github-actions/contexts)

### Community
- [GitHub Community Forums](https://github.community/)
- [GitHub Discussions on Actions](https://github.com/orgs/community/discussions/categories/actions)
- [Awesome GitHub Actions](https://github.com/sdras/awesome-actions)

### Tools
- [Actionlint](https://github.com/rhysd/actionlint) - Validate workflows
- [GitHub CLI](https://cli.github.com/) - Run workflows locally
- [Act](https://github.com/nektos/act) - Run workflows locally

---

## 🎯 Your Learning Goals

By the end of this course, you should be able to:

✅ Create workflows from scratch
✅ Debug workflow issues
✅ Use GitHub Actions marketplace effectively
✅ Build CI/CD pipelines
✅ Optimize workflow performance
✅ Follow security best practices
✅ Help team members with GitHub Actions

---

## 📝 Notes for Your Journey

**Remember:** GitHub Actions is a tool for automation. Start simple and add complexity as you learn.

**Pro Tips:**
- 💾 Save frequently; GitHub auto-saves in web editor
- 🧪 Test in dry-run mode before deploying
- 📖 Read example workflows from popular projects
- 🔐 Never commit secrets; use repository secrets
- 📊 Monitor execution times and optimize
- 🤝 Share knowledge with your team

---

**Happy Learning! 🚀**

---

*Last Updated: March 2026*
*Course Version: 1.0*
