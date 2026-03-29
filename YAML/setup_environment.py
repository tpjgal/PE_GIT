#!/usr/bin/env python3
"""
YAML Environment Setup Check
Verifies and sets up the YAML working environment.
"""

import subprocess
import sys
import os
from pathlib import Path


def print_header(title):
    """Print a formatted header."""
    print(f"\n{'='*70}")
    print(f"  {title}")
    print(f"{'='*70}\n")


def check_python():
    """Check Python version."""
    print_header("1️⃣  Python Information")
    
    print(f"Python Version: {sys.version}")
    print(f"Python Executable: {sys.executable}")
    print(f"Python Path: {sys.prefix}")


def check_packages():
    """Check if required packages are installed."""
    print_header("2️⃣  Package Status")
    
    packages = {
        'yaml': 'PyYAML',
        'json': 'JSON (built-in)',
        'pathlib': 'pathlib (built-in)',
    }
    
    for module_name, display_name in packages.items():
        try:
            if module_name == 'json' or module_name == 'pathlib':
                print(f"✅ {display_name}: Available (built-in)")
            else:
                __import__(module_name)
                print(f"✅ {display_name}: Available")
        except ImportError:
            print(f"❌ {module_name} ({display_name}): NOT installed")
            return False
    
    return True


def install_pyyaml():
    """Install PyYAML if not present."""
    print_header("3️⃣  Installing PyYAML")
    
    try:
        import yaml
        print("✅ PyYAML is already installed")
        return True
    except ImportError:
        print("📦 Installing PyYAML...")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "pyyaml", "-q"])
            print("✅ PyYAML installed successfully")
            return True
        except subprocess.CalledProcessError:
            print("❌ Failed to install PyYAML")
            print("   Try manually: pip install pyyaml")
            return False


def check_yaml_files():
    """Check YAML files in the workspace."""
    print_header("4️⃣  YAML Files in Workspace")
    
    yaml_dir = r"c:\Users\ponni\source\repos\PE_GIT\YAML"
    
    if not Path(yaml_dir).exists():
        print(f"❌ Directory not found: {yaml_dir}")
        return
    
    yaml_files = sorted(Path(yaml_dir).glob("*.yaml"))
    other_files = sorted(Path(yaml_dir).glob("*.md"))
    scripts = sorted(Path(yaml_dir).glob("*.py"))
    
    print(f"📂 Directory: {yaml_dir}\n")
    
    if yaml_files:
        print("📋 YAML Files:")
        for f in yaml_files:
            size = f.stat().st_size
            print(f"   ✅ {f.name} ({size:,} bytes)")
    
    if other_files:
        print("\n📚 Documentation:")
        for f in other_files:
            print(f"   📄 {f.name}")
    
    if scripts:
        print("\n🐍 Python Scripts:")
        for f in scripts:
            print(f"   🔧 {f.name}")


def test_yaml_parsing():
    """Test YAML parsing with a simple example."""
    print_header("5️⃣  Testing YAML Parsing")
    
    try:
        import yaml
        
        test_yaml = """
person:
  name: John Doe
  age: 30
  skills:
    - Python
    - JavaScript
    - YAML
"""
        
        data = yaml.safe_load(test_yaml)
        
        print("✅ YAML parsing works!")
        print(f"\nTest YAML content parsed successfully:")
        print(f"   Name: {data['person']['name']}")
        print(f"   Age: {data['person']['age']}")
        print(f"   Skills: {', '.join(data['person']['skills'])}")
        
        return True
    
    except Exception as e:
        print(f"❌ Test failed: {e}")
        return False


def show_next_steps():
    """Show next steps."""
    print_header("📋 Next Steps")
    
    print("""
1. ✅ Study the learning materials:
   - Read: YAML_BASICS_GUIDE.md
   - Reference: QUICK_REFERENCE.md

2. 🔍 Validate your YAML files:
   - Run: python validate_yaml.py

3. 📊 Parse and visualize YAML:
   - Run: python parse_yaml.py

4. 💻 Practice with exercises:
   - Complete: 04_exercises.md
   - Validate: https://www.yamllint.com/

5. 🚀 Real-world applications:
   - Study: 03_real_world_examples.yaml
   - Try Docker Compose or Kubernetes YAML
""")


def main():
    """Main function."""
    
    print("\n")
    print("╔" + "="*68 + "╗")
    print("║" + " "*15 + "YAML ENVIRONMENT SETUP CHECK" + " "*24 + "║")
    print("╚" + "="*68 + "╝")
    
    check_python()
    
    if not check_packages():
        print("\n⚠️  Some packages are missing.")
    
    if install_pyyaml():
        test_yaml_parsing()
    
    check_yaml_files()
    
    show_next_steps()
    
    print("="*70)
    print("✅ Setup Complete! You're ready to work with YAML.")
    print("="*70 + "\n")


if __name__ == "__main__":
    main()
