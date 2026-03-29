# YAML Basics Guide

## What is YAML?
YAML (YAML Ain't Markup Language) is a human-readable data serialization language commonly used for:
- Configuration files (Docker, Kubernetes, Ansible, GitHub Actions)
- Data exchange (similar to JSON, but more readable)
- Infrastructure as Code (IaC)

## Core Principles
1. **Human-readable** - Uses indentation instead of brackets
2. **Whitespace sensitive** - Indentation defines structure
3. **Type detection** - Automatically detects data types
4. **Comments** - Use `#` for comments

---

## Basic Data Types

### 1. Strings
```yaml
# Simple string
name: John Doe

# String with special characters
description: "This is a string with: special characters!"

# Multiline string (literal - preserves newlines)
poem: |
  Roses are red
  Violets are blue
  YAML is great
  And so are you

# Multiline string (folded - removes newlines, keeps spaces)
bio: >
  This is a long description
  that spans multiple lines
  but will be folded into
  a single line with spaces.
```

### 2. Numbers
```yaml
integer: 42
float: 3.14
scientific: 1.23e-4
octal: 0o755
hexadecimal: 0xFF
```

### 3. Booleans
```yaml
# True values
enabled: true
active: yes
running: on

# False values
disabled: false
inactive: no
stopped: off
```

### 4. Null Values
```yaml
nothing: null
also_nothing: ~
undefined:
```

### 5. Lists (Arrays)
```yaml
# List style (preferred)
fruits:
  - apple
  - banana
  - orange

# Inline list style
colors: [red, green, blue]

# Mixed content
items:
  - name: item1
    value: 10
  - name: item2
    value: 20
```

### 6. Maps (Dictionaries/Objects)
```yaml
# Block style (preferred)
person:
  name: John
  age: 30
  city: New York

# Inline style
coordinates: {x: 10, y: 20, z: 30}

# Nested maps
company:
  name: TechCorp
  departments:
    engineering:
      team_lead: Alice
      members: 15
    sales:
      team_lead: Bob
      members: 8
```

---

## Indentation Rules

**Critical**: Use spaces, NOT tabs!
- Standard: 2 spaces per indentation level
- Consistent indentation is mandatory

```yaml
# ✓ CORRECT
parent:
  child1:
    - item1
    - item2
  child2: value

# ✗ WRONG - Inconsistent indentation
parent:
  child1:
    - item1
   - item2
```

---

## Advanced Features

### 1. Anchors and Aliases (DRY - Don't Repeat Yourself)
```yaml
# Define an anchor with &
default_settings: &default_config
  timeout: 30
  retries: 3

# Reference with * (alias)
development:
  <<: *default_config
  debug: true

production:
  <<: *default_config
  debug: false
```

### 2. Tags (Type Hints)
```yaml
date: !!str 2024-01-15    # Force string type
number: !!int "42"         # Force integer type
flag: !!bool "yes"         # Force boolean
```

### 3. Multi-document YAML
```yaml
---
# Document 1
name: Document One
---
# Document 2
name: Document Two
```

---

## Common Patterns

### Configuration File
```yaml
database:
  host: localhost
  port: 5432
  user: admin
  password: secret
  options:
    pool_size: 10
    timeout: 30

logging:
  level: info
  format: json
  output: /var/log/app.log
```

### List of Objects
```yaml
employees:
  - id: 1
    name: Alice
    role: Developer
    salary: 80000
  - id: 2
    name: Bob
    role: Designer
    salary: 75000
  - id: 3
    name: Charlie
    role: Manager
    salary: 90000
```

### Conditional-like Structure
```yaml
environments:
  dev:
    database: dev_db
    debug: true
    replica_count: 1
  
  prod:
    database: prod_db
    debug: false
    replica_count: 3
```

---

## Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Using tabs | Invalid indentation | Use spaces only |
| `: ` missing | Parser fails | Always space after colon |
| Wrong indentation | Structure broken | Count spaces carefully |
| Unquoted special chars | Type confusion | Quote strings with `@`, `#`, `:`, etc. |
| Inconsistent list markers | Parse error | Use `-` consistently |

---

## Validation

Use online validators or tools:
- [yamllint](https://www.yamllint.com/) - Online YAML validator
- `yamllint file.yaml` - Command line tool (Python)
- Most editors have YAML extensions with validation

---

## Quick Reference

```yaml
# Syntax comparison
# Maps/Objects:
key: value
nested:
  sub_key: sub_value

# Lists/Arrays:
items:
  - item1
  - item2

# Comments
# This is a comment

# Anchor & Alias
anchor: &my_anchor
  key: value
alias_ref: *my_anchor

# Multi-line strings
literal: |
  Preserves newlines
  Like this
folded: >
  Folds newlines
  into spaces
```

---

## Real-World Examples

### Docker Compose
```yaml
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    environment:
      - ENVIRONMENT=production
    volumes:
      - ./html:/usr/share/nginx/html
```

### Kubernetes Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: app
    image: my-app:latest
    ports:
    - containerPort: 8080
    env:
    - name: DEBUG
      value: "false"
```

### GitHub Actions Workflow
```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: npm test
```

---

## Learning Checklist

- [ ] Understand basic data types (string, number, boolean, null)
- [ ] Know the difference between lists and maps
- [ ] Practice correct indentation with spaces
- [ ] Learn about anchors and aliases
- [ ] Write a configuration file from scratch
- [ ] Validate YAML files
- [ ] Study real-world YAML (docker-compose, k8s, GitHub Actions)
- [ ] Practice converting between YAML and JSON

---

## Next Steps

1. Create sample YAML files in this folder
2. Validate them using online tools or yamllint
3. Practice writing configuration files
4. Study YAML files in real projects (GitHub, Docker Hub)
5. Learn tool-specific YAML (Kubernetes, Ansible, GitHub Actions)

