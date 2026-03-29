#!/usr/bin/env python3
"""
YAML Validation Tool
Validates YAML files and reports any syntax errors or issues.
"""

import sys
import os
from pathlib import Path

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML is not installed.")
    print("Install it with: pip install pyyaml")
    sys.exit(1)


def validate_yaml_file(filepath):
    """Validate a YAML file and report results."""
    
    if not os.path.exists(filepath):
        print(f"❌ File not found: {filepath}")
        return False
    
    print(f"\n{'='*60}")
    print(f"VALIDATING: {Path(filepath).name}")
    print(f"{'='*60}")
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Parse YAML
        documents = list(yaml.safe_load_all(content))
        
        print(f"✅ VALID YAML")
        print(f"📄 Total documents: {len(documents)}")
        
        for idx, doc in enumerate(documents, 1):
            if doc is None:
                print(f"   Document {idx}: Empty/Null")
            elif isinstance(doc, dict):
                print(f"   Document {idx}: Map with {len(doc)} keys")
                print(f"      Top-level keys: {', '.join(doc.keys())}")
            elif isinstance(doc, list):
                print(f"   Document {idx}: List with {len(doc)} items")
            else:
                print(f"   Document {idx}: {type(doc).__name__}")
        
        return True
        
    except yaml.YAMLError as e:
        print(f"❌ YAML SYNTAX ERROR")
        print(f"   Error: {str(e)}")
        return False
    except Exception as e:
        print(f"❌ ERROR: {str(e)}")
        return False


def main():
    """Main function."""
    
    yaml_dir = r"c:\Users\ponni\source\repos\PE_GIT\YAML"
    yaml_files = list(Path(yaml_dir).glob("*.yaml"))
    
    if not yaml_files:
        print("❌ No YAML files found!")
        return
    
    print("\n" + "="*60)
    print("YAML VALIDATION TOOL")
    print("="*60)
    
    valid_count = 0
    invalid_count = 0
    
    for yaml_file in sorted(yaml_files):
        if validate_yaml_file(str(yaml_file)):
            valid_count += 1
        else:
            invalid_count += 1
    
    print(f"\n{'='*60}")
    print("SUMMARY")
    print(f"{'='*60}")
    print(f"✅ Valid files: {valid_count}")
    print(f"❌ Invalid files: {invalid_count}")
    print(f"📊 Total: {valid_count + invalid_count}")
    print(f"{'='*60}\n")


if __name__ == "__main__":
    main()
