# YAML Environment - Tool Usage Guide

## Overview

Your YAML environment includes 3 powerful Python tools for working with YAML files:

1. **validate_yaml.py** - Validates YAML syntax
2. **parse_yaml.py** - Parses and visualizes YAML structure
3. **setup_environment.py** - Verifies environment setup

---

## Tool 1: validate_yaml.py

### Purpose
Validates all YAML files in the workspace and reports any syntax errors.

### Usage
```powershell
python validate_yaml.py
```

### Output Example
```
============================================================
YAML VALIDATION TOOL
============================================================

============================================================
VALIDATING: 01_basic_types.yaml
============================================================
✅ VALID YAML
📄 Total documents: 1
   Document 1: Map with 17 keys
      Top-level keys: title, description, author, ...

============================================================
SUMMARY
============================================================
✅ Valid files: 3
❌ Invalid files: 0
📊 Total: 3
============================================================
```

### What It Checks
- ✅ Valid YAML syntax
- ✅ Number of documents in file
- ✅ Top-level structure (map, list, or scalar)
- ✅ Number of keys/items
- ✅ Specific error messages for invalid YAML

### When to Use
- Before deploying configuration files
- When debugging YAML syntax errors
- To get an overview of all YAML files
- Before checking into version control

---

## Tool 2: parse_yaml.py

### Purpose
Parses YAML files and visualizes their structure, converts to JSON format.

### Usage
```powershell
python parse_yaml.py
```

### Output Sections
Each file shows:
1. **Document count** - Number of YAML documents
2. **Structure** - Tree view of data hierarchy
3. **JSON representation** - Converted to JSON (first document only)

### Structure Visualization

**Example Input (YAML):**
```yaml
database:
  host: localhost
  credentials:
    username: admin
    password: secret
```

**Example Output:**
```
📂 database:
  📄 host: (str) localhost
  📂 credentials:
    📄 username: (str) admin
    📄 password: (str) secret
```

### Data Type Detection
Shows detected types:
- `(str)` - String
- `(int)` - Integer
- `(float)` - Float
- `(bool)` - Boolean
- `(list)` - Array
- `(dict)` - Object/Map

### When to Use
- Understand YAML file structure
- Debug complex nested YAML
- Convert YAML to JSON format
- Verify data types were parsed correctly
- Explore unfamiliar YAML files

---

## Tool 3: setup_environment.py

### Purpose
Verifies your Python environment and YAML setup.

### Usage
```powershell
python setup_environment.py
```

### Checks Performed
1. Python version and location
2. Required packages (PyYAML, json, pathlib)
3. Installs PyYAML if missing
4. Tests YAML parsing
5. Lists all YAML files in workspace
6. Suggests next steps

### Output Includes
```
1️⃣  Python Information
- Python Version, Executable, Path

2️⃣  Package Status
- Installed packages check

3️⃣  Installing PyYAML
- Automatic installation (if needed)

4️⃣  YAML Files in Workspace
- Lists all .yaml, .md, and .py files

5️⃣  Testing YAML Parsing
- Verifies YAML parsing works

📋 Next Steps
- Suggested learning path
```

### When to Use
- Initial environment setup
- Troubleshooting import errors
- Verifying all dependencies installed
- After Python updates
- In new user onboarding

---

## Workflow Examples

### Workflow 1: Validate New Configuration File

```powershell
# 1. Create your YAML file
# (create my-config.yaml)

# 2. Validate it
python validate_yaml.py

# 3. If invalid, check the error
# Fix your YAML syntax

# 4. Re-validate
python validate_yaml.py

# 5. Parse to see structure
python parse_yaml.py
```

### Workflow 2: Debug Complex YAML

```powershell
# 1. Parse to visualize structure
python parse_yaml.py

# 2. Look for the structure you expected
# 3. Check indentation and formatting

# 4. Validate for syntax errors
python validate_yaml.py

# 5. If structure is wrong, adjust YAML
# 6. Go back to step 1
```

### Workflow 3: Convert YAML to JSON

```powershell
# 1. Run parser
python parse_yaml.py

# 2. Look for "JSON Representation" section
# 3. Copy JSON output
# 4. Use in your application
```

### Workflow 4: Environment Troubleshooting

```powershell
# If you get import errors:

# 1. Check environment
python setup_environment.py

# 2. Install missing packages
pip install pyyaml

# 3. Re-run setup
python setup_environment.py

# 4. Verify everything works
python validate_yaml.py
```

---

## Common Use Cases

### Use Case 1: Learning YAML
```powershell
# Read the guide
# cat YAML_BASICS_GUIDE.md

# Study examples
# cat 01_basic_types.yaml

# Parse to understand structure
python parse_yaml.py

# Try exercises in 04_exercises.md
```

### Use Case 2: Setting Up CI/CD

```powershell
# Create GitHub Actions workflow YAML
# Validate it
python validate_yaml.py

# Parse to verify structure
python parse_yaml.py

# Check for errors before pushing
```

### Use Case 3: Docker Compose Configuration

```powershell
# Create docker-compose.yaml
# (or move it to this directory)

# Validate
python validate_yaml.py

# Parse to see services
python parse_yaml.py

# Fix any issues found
```

### Use Case 4: Kubernetes Manifests

```powershell
# Place Kubernetes YAML files here
# Validate all of them
python validate_yaml.py

# Parse to understand pod specs
python parse_yaml.py

# Deploy with confidence
```

---

## Tips and Best Practices

### ✅ Do's

- **Do use tabs spaces** - Set your editor to 2-space indentation
- **Do validate before deploying** - Always run `validate_yaml.py` first
- **Do parse to visualize** - Use `parse_yaml.py` to understand structure
- **Do quote special characters** - Use quotes around `@#$:[]{}?`
- **Do keep files organized** - Put related YAML files together
- **Do use meaningful names** - Name files clearly (config.yaml, deployment.yaml)

### ❌ Don'ts

- **Don't use tabs** - Only spaces for indentation
- **Don't forget colons** - Every key needs a colon: `key: value`
- **Don't mix spaces** - Use consistent indentation levels
- **Don't ignore errors** - Fix validation errors immediately
- **Don't assume structure** - Always parse to verify
- **Don't edit without validation** - Check after each change

---

## Extending the Tools

### Modify validate_yaml.py to Check Specific Fields

```python
# Add after parsing
if 'services' in documents[0]:
    print(f"Found {len(documents[0]['services'])} services")
```

### Add Custom Validation Rules

```python
# Add your own checks
if not documents[0].get('version'):
    print("⚠️  Warning: No version specified")
```

### Export to Different Formats

```python
import json
import csv

# Export to JSON
with open('output.json', 'w') as f:
    json.dump(documents[0], f)

# Export to CSV (for specific data)
```

---

## Troubleshooting

### Problem: "No module named 'yaml'"
**Solution:**
```powershell
pip install pyyaml
# Or
python setup_environment.py
```

### Problem: File not found errors
**Solution:**
- Ensure files are in `c:\Users\ponni\source\repos\PE_GIT\YAML`
- Check file extensions are `.yaml` (not `.yml`)
- Use full paths if running from different directory

### Problem: Indentation errors
**Solution:**
```powershell
# Run parser to see indentation
python parse_yaml.py

# Check for tabs in your editor
# Use spaces only (2 per level)
```

### Problem: Encoding issues
**Solution:**
- Save files as UTF-8 without BOM
- Check for special characters
- Validate file encoding in editor

---

## Integration with Other Tools

### With Git Pre-commit Hooks
```bash
#!/bin/bash
python validate_yaml.py
if [ $? -ne 0 ]; then
    echo "YAML validation failed"
    exit 1
fi
```

### With Text Editor (VS Code)

**Settings:**
```json
"[yaml]": {
    "editor.insertSpaces": true,
    "editor.tabSize": 2,
    "editor.formatOnSave": true
}
```

**Extensions:**
- YAML (Red Hat)
- YAML Validator

### With CI/CD Pipelines

**GitHub Actions:**
```yaml
- name: Validate YAML
  run: python validate_yaml.py
```

**GitLab CI:**
```yaml
validate_yaml:
  script:
    - python validate_yaml.py
```

---

## Performance Notes

| Tool | Speed | Memory | Use For |
|------|-------|--------|---------|
| validate_yaml.py | Fast | Low | Quick validation |
| parse_yaml.py | Fast | Medium | Structure visualization |
| setup_environment.py | Slow | Low | One-time setup |

---

## Next Steps

1. ✅ Environment is set up
2. 📚 Read [YAML_BASICS_GUIDE.md](YAML_BASICS_GUIDE.md)
3. 🔍 Validate files: `python validate_yaml.py`
4. 📊 Parse files: `python parse_yaml.py`
5. 📝 Complete exercises: [04_exercises.md](04_exercises.md)
6. 🚀 Apply to real projects

---

**Version**: 1.0
**Last Updated**: 2026-03-29
**Status**: ✅ Ready for Production

