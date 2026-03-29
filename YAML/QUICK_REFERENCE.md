# YAML Quick Reference Cheat Sheet

## Syntax at a Glance

```yaml
# Comments start with #

# Key-value pair
key: value

# Strings (quotes optional unless special chars)
string: hello
quoted: "hello world"
special: "key:value@#$"

# Numbers
integer: 42
float: 3.14
scientific: 1.23e-4

# Booleans
bool_true: true
bool_false: false

# Null
null_value: null
also_null: ~

# Lists (arrays)
list:
  - item1
  - item2
  - item3

# Inline list
inline_list: [item1, item2, item3]

# Maps (objects)
map:
  key1: value1
  key2: value2

# Inline map
inline_map: {key1: value1, key2: value2}

# Nested structures
nested:
  level1:
    level2:
      - item1
      - item2

# Multi-line strings
literal: |
  Line 1
  Line 2
  Preserves newlines

folded: >
  Line 1
  Line 2
  Folds into single line

# Anchor and Alias
anchor: &my_anchor
  key: value
alias: *my_anchor
```

---

## Key Rules

| Rule | Example |
|------|---------|
| Always space after `:` | `key: value` ✓ / `key:value` ✗ |
| Use spaces, not tabs | Indentation only with spaces |
| Consistent indentation | 2 spaces per level |
| Quote special chars | `"@#$:[]{}?"` → quotes needed |
| List marker alignment | All `-` at same indentation |
| Comment anywhere | `value: 123 # comment` or `# full line` |

---

## Common Patterns

### Configuration File
```yaml
app:
  name: MyApp
  version: 1.0
  settings:
    debug: false
    timeout: 30
```

### List of Objects
```yaml
users:
  - id: 1
    name: Alice
  - id: 2
    name: Bob
```

### Inheritance/Defaults
```yaml
defaults: &defaults
  timeout: 30
  retries: 3

prod:
  <<: *defaults
  debug: false
```

### Environment Variables
```yaml
env:
  DATABASE_URL: "postgresql://localhost/db"
  DEBUG: "false"
  LOG_LEVEL: "info"
```

### Conditional Structure
```yaml
environments:
  dev:
    debug: true
    replicas: 1
  prod:
    debug: false
    replicas: 3
```

---

## Data Type Detection

YAML automatically detects types:

```yaml
# Detected as string
version: "1.0"
code: "007"

# Detected as number
count: 42
price: 19.99

# Detected as boolean
active: true
done: false

# Detected as null
empty: null

# Detected as list
items: [1, 2, 3]

# Detected as map
config: {key: value}
```

---

## Special Characters

Quote these strings:

```yaml
special_chars:
  colon: "key: value"
  at_sign: "user@domain.com"
  hash: "hashtag #awesome"
  brackets: "[item1, item2]"
  braces: "{key: value}"
  question: "what?"
  asterisk: "5 * 4 = 20"
  pipe: "use | for OR"
  ampersand: "Tom & Jerry"
```

---

## Multi-line Strings

### Literal (|) - Preserves newlines
```yaml
poem: |
  Roses are red
  Violets are blue
  This preserves
  the line breaks
```

### Folded (>) - Joins with spaces
```yaml
summary: >
  This is a long
  text that spans
  multiple lines
  but becomes one
```

---

## Anchors & Aliases

Define once, use multiple times:

```yaml
# Define with &name
defaults: &default_db
  driver: mysql
  port: 3306

# Use with *name
dev:
  database:
    <<: *default_db
    host: localhost

prod:
  database:
    <<: *default_db
    host: prod-server
    pool: 50
```

---

## Common Mistakes

| Mistake | Issue | Fix |
|---------|-------|-----|
| `key:value` | No space after `:` | `key: value` |
| Tab indentation | Invalid | Use spaces |
| Misaligned lists | Structure broken | Align all `-` |
| Unquoted special chars | Parse error | Add quotes |
| Wrong indentation | Wrong nesting | Count spaces |
| `- - item` | Double dash | Use `- item` |
| `: value` at start | Invalid | Use `key: value` |

---

## Validation

### Online Tools
- [yamllint.com](https://www.yamllint.com/)
- [jsonschemalint.com](https://www.jsonschemalint.com/)

### Command Line
```bash
# Install yamllint (Python)
pip install yamllint

# Validate file
yamllint config.yaml
```

---

## Real-World Examples

### Docker Compose
```yaml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "80:80"
```

### Kubernetes
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: app
    image: my-app:latest
```

### GitHub Actions
```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
```

### Ansible Playbook
```yaml
- hosts: web_servers
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
```

---

## Quick Decision Tree

```
Is it a key-value pair?
└─ YES: key: value
└─ NO: Is it a list?
   └─ YES: Use - or [item1, item2]
   └─ NO: Is it nested?
      └─ YES: Indent properly
      └─ NO: Use inline format {key: value}
```

---

## Practice Checklist

- [ ] Created your first YAML file
- [ ] Used all basic data types
- [ ] Created nested structures
- [ ] Used lists and maps
- [ ] Applied multi-line strings
- [ ] Used anchors and aliases
- [ ] Validated your YAML files
- [ ] Read real-world YAML examples
- [ ] Resolved indentation issues
- [ ] Quoted special characters correctly

---

## Resources

- Official: https://yaml.org/
- Cheat Sheet: https://devhints.io/yaml
- Tutorial: https://www.cloudbees.com/blog/yaml-tutorial-everything-you-need-get-started
- Playground: https://www.yamllint.com/

