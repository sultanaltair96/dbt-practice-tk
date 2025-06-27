"""
Setup script for the Tesla Data Analysis project.
This script will install all required dependencies and verify the environment.
"""
import sys
import subprocess
import os
from pathlib import Path

def check_python_version():
    """Check if Python version is compatible"""
    required_major = 3
    required_minor = 8
    
    current = sys.version_info
    if current.major < required_major or (current.major == required_major and current.minor < required_minor):
        print(f"ERROR: Python {required_major}.{required_minor}+ is required. You have {current.major}.{current.minor}")
        return False
    
    print(f"Python version check passed: {current.major}.{current.minor}.{current.micro}")
    return True

def install_dependencies():
    """Install required packages from requirements.txt"""
    requirements_file = Path(__file__).parent / "requirements.txt"
    
    if not requirements_file.exists():
        print("ERROR: requirements.txt file not found")
        return False
    
    print("Installing dependencies...")
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-r", str(requirements_file)])
        print("Dependencies installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"ERROR: Failed to install dependencies: {e}")
        return False

def check_dbt():
    """Verify dbt is installed and accessible"""
    try:
        subprocess.check_call([sys.executable, "-m", "dbt", "--version"], 
                             stdout=subprocess.PIPE, 
                             stderr=subprocess.PIPE)
        print("dbt installation verified")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("ERROR: dbt not properly installed or not in PATH")
        return False

def check_duckdb():
    """Verify DuckDB is installed and can be imported"""
    try:
        import duckdb
        print(f"DuckDB installation verified (version: {duckdb.__version__})")
        return True
    except ImportError:
        print("ERROR: DuckDB not properly installed")
        return False

def check_csv_file():
    """Check if the Tesla CSV file exists"""
    csv_path = Path(__file__).parent / "tesla_results.csv"
    
    if csv_path.exists():
        size_mb = csv_path.stat().st_size / (1024 * 1024)
        print(f"Tesla CSV file found ({size_mb:.2f} MB)")
        return True
    else:
        print("WARNING: tesla_results.csv file not found in project directory")
        return False

def setup_profile():
    """Ensure the dbt profile is properly set up"""
    profile_path = Path(__file__).parent / "profiles.yml"
    
    if not profile_path.exists():
        print("WARNING: profiles.yml file not found")
        return False
    
    # In a real setup, you might want to copy this to ~/.dbt/ directory
    # For simplicity, we'll just verify it exists in the project directory
    print("dbt profile found in project directory")
    return True

def main():
    """Main setup function"""
    print("=== Tesla Data Analysis Project Setup ===\n")
    
    all_checks_passed = True
    
    # Run all checks
    if not check_python_version():
        all_checks_passed = False
    
    if not install_dependencies():
        all_checks_passed = False
    
    if not check_dbt():
        all_checks_passed = False
    
    if not check_duckdb():
        all_checks_passed = False
    
    if not check_csv_file():
        print("Note: You'll need to make sure tesla_results.csv is in the project directory")
    
    if not setup_profile():
        all_checks_passed = False
    
    # Summary
    print("\n=== Setup Summary ===")
    if all_checks_passed:
        print("✅ All essential checks passed!")
        print("\nYou can now run the following commands:")
        print("  python csv_explorer.py     # To explore your CSV file structure")
        print("  python duckdb_demo.py      # To test DuckDB functionality")
        print("  dbt run --profiles-dir .   # To run your dbt models")
    else:
        print("❌ Some checks failed. Please fix the issues above before proceeding.")
    
    return all_checks_passed

if __name__ == "__main__":
    sys.exit(0 if main() else 1)
