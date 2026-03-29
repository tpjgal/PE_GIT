#!/usr/bin/env python3
"""
YAML Parser and Converter
Parse YAML files and visualize structure, convert to JSON.
"""

import sys
import json
from pathlib import Path

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML is not installed.")
    print("Install it with: pip install pyyaml")
    sys.exit(1)


def print_structure(data, level=0, max_level=3):
    """Print YAML structure in a readable format."""
    
    indent = "  " * level
    
    if level > max_level:
        print(f"{indent}[... structure too deep, truncated ...]")
        return
    
    if isinstance(data, dict):
        for key, value in list(data.items())[:10]:  # Show first 10 items
            if isinstance(value, (dict, list)):
                print(f"{indent}📂 {key}:")
                print_structure(value, level + 1, max_level)
            else:
                value_type = type(value).__name__
                value_preview = str(value)[:50]
                if len(str(value)) > 50:
                    value_preview += "..."
                print(f"{indent}📄 {key}: ({value_type}) {value_preview}")
        
        if len(data) > 10:
            print(f"{indent}... and {len(data) - 10} more keys")
    
    elif isinstance(data, list):
        for idx, item in enumerate(list(data)[:5]):  # Show first 5 items
            if isinstance(item, (dict, list)):
                print(f"{indent}[{idx}]:")
                print_structure(item, level + 1, max_level)
            else:
                item_type = type(item).__name__
                item_preview = str(item)[:50]
                if len(str(item)) > 50:
                    item_preview += "..."
                print(f"{indent}[{idx}] ({item_type}) {item_preview}")
        
        if len(data) > 5:
            print(f"{indent}... and {len(data) - 5} more items")
    
    else:
        print(f"{indent}{data}")


def parse_yaml_file(filepath):
    """Parse a YAML file and display its structure."""
    
    if not Path(filepath).exists():
        print(f"❌ File not found: {filepath}")
        return
    
    print(f"\n{'='*70}")
    print(f"PARSING: {Path(filepath).name}")
    print(f"{'='*70}\n")
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Parse all YAML documents
        documents = list(yaml.safe_load_all(content))
        
        print(f"📊 Document count: {len(documents)}")
        
        for doc_idx, doc in enumerate(documents, 1):
            if len(documents) > 1:
                print(f"\n--- Document {doc_idx} ---")
            
            if doc is None:
                print("(Empty document)")
            else:
                print(f"📋 Structure:")
                print_structure(doc)
        
        # Show first document as JSON
        if documents and documents[0] is not None:
            print(f"\n{'─'*70}")
            print("JSON Representation (first document):")
            print(f"{'─'*70}")
            json_str = json.dumps(documents[0], indent=2)
            if len(json_str) > 1000:
                print(json_str[:1000])
                print(f"\n... (truncated, total {len(json_str)} chars)")
            else:
                print(json_str)
        
    except yaml.YAMLError as e:
        print(f"❌ YAML ERROR: {e}")
    except Exception as e:
        print(f"❌ ERROR: {e}")


def main():
    """Main function."""
    
    yaml_dir = r"c:\Users\ponni\source\repos\PE_GIT\YAML"
    yaml_files = sorted(Path(yaml_dir).glob("*.yaml"))
    
    print("="*70)
    print("YAML PARSER - Structure Visualization")
    print("="*70)
    
    for yaml_file in yaml_files:
        parse_yaml_file(str(yaml_file))
    
    print(f"\n{'='*70}")
    print(f"✅ Parsed {len(yaml_files)} YAML files")
    print(f"{'='*70}\n")


if __name__ == "__main__":
    main()
