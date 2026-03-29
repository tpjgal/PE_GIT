# GitHub Actions Learning Guide

## Overview
This guide will teach you GitHub Actions fundamentals from scratch, progressing step by step from basic concepts to practical workflows.

## What You'll Learn
1. **GitHub Actions Basics** - Core concepts and terminology
2. **Workflow Structure** - Anatomy of a workflow file
3. **Triggers** - When workflows run
4. **Jobs & Steps** - How to organize work
5. **Actions** - Reusable components
6. **Practical Examples** - Real-world workflows
7. **Best Practices** - Industry standards

## Prerequisites
- GitHub account (free tier is fine)
- A GitHub repository
- Basic understanding of YAML syntax
- Basic command line knowledge

## Learning Path
Follow the numbered lessons in order. Each lesson builds on the previous one.

**Time Estimate**: 2-3 hours for complete understanding

---

## Quick Start: What is GitHub Actions?

**GitHub Actions** is GitHub's native automation platform that lets you:
- Run code automatically on events (push, pull requests, schedule, manual trigger)
- Test code in real environments
- Build and deploy applications
- Create workflows without leaving GitHub
- Run on GitHub-hosted runners (free) or your own servers

**Key Benefits:**
✅ No external CI/CD tool needed
✅ Integrated with repositories
✅ Free for public repos and GitHub-hosted runners
✅ Matrix builds (test on multiple OS, versions)
✅ Extensive marketplace of actions

---

## Table of Contents

1. [Lesson 1: Core Concepts](./01-core-concepts.md)
2. [Lesson 2: Workflow Anatomy](./02-workflow-anatomy.md)
3. [Lesson 3: Triggers & Events](./03-triggers-events.md)
4. [Lesson 4: Jobs & Steps](./04-jobs-steps.md)
5. [Lesson 5: Actions & Marketplace](./05-actions-marketplace.md)
6. [Lesson 6: Practical Examples](./06-practical-examples.md)
7. [Lesson 7: Best Practices](./07-best-practices.md)

---

## How to Use This Guide

Each lesson includes:
- **Concepts** - Explanation of the topic
- **Syntax** - YAML examples
- **Example Workflow** - Ready-to-use workflow file
- **Practice Exercise** - Try it yourself
- **Key Takeaways** - Summary

**Tip:** Download the example workflow files to your repository's `.github/workflows/` directory to see them in action!

---

## Directory Structure

```
GitHub Action/
├── README.md (this file)
├── 01-core-concepts.md
├── 02-workflow-anatomy.md
├── 03-triggers-events.md
├── 04-jobs-steps.md
├── 05-actions-marketplace.md
├── 06-practical-examples.md
├── 07-best-practices.md
└── examples/
    ├── hello-world.yml
    ├── build-and-test.yml
    ├── matrix-build.yml
    ├── scheduled-task.yml
    └── deployment.yml
```

---

## Common Terminology Cheat Sheet

| Term | Meaning |
|------|---------|
| **Workflow** | Automated process defined in `.github/workflows/*.yml` |
| **Trigger** | Event that causes workflow to run (e.g., push, pull_request, schedule) |
| **Job** | Set of steps executed on same runner |
| **Step** | Individual task in a job (run command or use action) |
| **Action** | Reusable code/tool published in marketplace |
| **Runner** | Server that runs jobs (GitHub-hosted or self-hosted) |
| **Artifact** | Files generated and stored by a workflow |
| **Secret** | Encrypted variable for sensitive data |
| **Matrix** | Strategy to run jobs on multiple configurations |

---

Let's start learning! Begin with **Lesson 1: Core Concepts** →
