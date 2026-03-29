# YAML Exercises and Challenges

## Exercise 1: Basic Structure
Create a YAML file for a personal profile with:
- Name: (your preferred)
- Age: (number)
- Location: (string)
- Is_Student: (boolean)
- Languages: (list of at least 3 languages)

**Solution location: `solutions/01_profile.yaml`**

---

## Exercise 2: Nested Objects
Create a YAML configuration for a bookstore with:
- Store name
- Address (street, city, zip code)
- Operating hours (opening and closing times)
- List of departments with:
  - Department name
  - Manager name
  - Number of employees

**Solution location: `solutions/02_bookstore.yaml`**

---

## Exercise 3: Lists and Maps
Create a YAML file for a movie database containing:
- A list of at least 3 movies
- Each movie should have:
  - Title
  - Year
  - Rating (1-10)
  - Genre (list)
  - Director
  - Cast (list of actors)

**Solution location: `solutions/03_movies.yaml`**

---

## Exercise 4: Multi-line Strings
Create a YAML file with:
- A literal multi-line string (using |) with a poem or story
- A folded multi-line string (using >) with a description
- At least one quoted string with special characters

**Solution location: `solutions/04_multiline.yaml`**

---

## Exercise 5: Anchors and Aliases
Create a YAML configuration that uses anchors to avoid repetition:
- Define default settings for at least 3 environments (dev, staging, prod)
- Each environment should share common settings via aliases
- Override at least one setting per environment

**Solution location: `solutions/05_environments.yaml`**

---

## Exercise 6: Complex Nested Structure
Create a YAML file for a company organization with:
- Company name and headquarters location
- Multiple departments (at least 3)
- Each department has:
  - Department name
  - Budget
  - List of teams
  - Each team has:
    - Team name
    - Team lead
    - Technologies used (list)
    - Team members (list with name and role)

**Solution location: `solutions/06_company_org.yaml`**

---

## Exercise 7: Error Detection
Identify the errors in these YAML snippets:

### Snippet 1:
```yaml
person:
name: John
age: 30
```
**Error:** Improper indentation

### Snippet 2:
```yaml
items
  - item1
  - item2
```
**Error:** Missing colon after "items"

### Snippet 3:
```yaml
config:
	debug: true
	verbose: false
```
**Error:** Using tabs instead of spaces

### Snippet 4:
```yaml
data:
- item1
  - item2
- item3
```
**Error:** Inconsistent indentation in list

---

## Exercise 8: YAML to JSON Conversion
Convert this YAML to JSON format:
```yaml
person:
  name: Alice
  age: 28
  skills:
    - Python
    - JavaScript
    - Docker
```

**Expected JSON output:**
```json
{
  "person": {
    "name": "Alice",
    "age": 28,
    "skills": ["Python", "JavaScript", "Docker"]
  }
}
```

---

## Exercise 9: Create a Real-World Config
Create a YAML configuration file for one of these:
1. **GitHub Actions Workflow** - A CI/CD pipeline for testing and deploying code
2. **Docker Compose** - Multi-container application (web server, database, cache)
3. **Application Settings** - Configuration for a hypothetical web application

Include comments to explain each section.

---

## Exercise 10: Validation Challenge
After completing any exercise, validate your YAML files:

### Online Tools:
- YAML Validator: https://www.yamllint.com/
- JSON Schema Validator: https://www.jsonschemavalidator.net/

### Command Line (if installed):
```bash
yamllint filename.yaml
```

---

## Hints for Success

✓ Use an online YAML validator to check your syntax
✓ Remember: YAML uses **spaces**, never tabs
✓ Proper indentation is critical - each level should be +2 spaces
✓ Always include a space after the colon (`:`)
✓ For strings with special characters, use quotes
✓ Comments in YAML start with `#`
✓ Use anchors (`&`) and aliases (`*`) to reduce repetition

---

## Learning Path

1. **Start:** Exercise 1 (Basic Structure)
2. **Progress:** Exercises 2-4 (Intermediate)
3. **Challenge:** Exercises 5-6 (Advanced)
4. **Master:** Exercises 7-10 (Expert)

---

## Common YAML Mistakes to Avoid

| Mistake | Fix |
|---------|-----|
| `key:value` (no space) | Use `key: value` |
| Using tabs for indentation | Use spaces only |
| Inconsistent indentation levels | Count spaces carefully |
| Forgetting colons | Remember `key: value` needs `:` |
| Unquoted special characters | Quote strings with `@`, `#`, `:`, etc. |
| Wrong list syntax | Use `-` consistently at same indentation |

---

## Resources for Further Learning

- [Official YAML Spec](https://yaml.org/)
- [YAML Cheat Sheet](https://devhints.io/yaml)
- [Real-world YAML examples](https://github.com/trending?spoken_language_code=&q=yaml)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Kubernetes YAML Guide](https://kubernetes.io/docs/concepts/configuration/)
- [Ansible YAML Best Practices](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)
