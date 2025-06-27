"""
Run script for the Tesla Data Analysis project.
This script executes the full ETL pipeline using DuckDB and dbt.
"""
import os
import sys
import subprocess
import time
from pathlib import Path

def run_csv_explorer():
    """Run the CSV explorer script to analyze the data structure"""
    print("=== Running CSV Explorer ===")
    try:
        subprocess.check_call([sys.executable, "csv_explorer.py"])
        print("CSV exploration completed")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running CSV explorer: {e}")
        return False

def run_dbt():
    """Run the dbt models"""
    print("\n=== Running dbt Models ===")
    try:
        # Use local profiles.yml
        subprocess.check_call([sys.executable, "-m", "dbt", "run", "--profiles-dir", "."])
        print("dbt models executed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running dbt models: {e}")
        return False

def run_dbt_test():
    """Run dbt tests"""
    print("\n=== Running dbt Tests ===")
    try:
        subprocess.check_call([sys.executable, "-m", "dbt", "test", "--profiles-dir", "."])
        print("dbt tests completed")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running dbt tests: {e}")
        return False

def run_duckdb_demo():
    """Run the DuckDB demo script"""
    print("\n=== Running DuckDB Demo ===")
    try:
        subprocess.check_call([sys.executable, "duckdb_demo.py"])
        print("DuckDB demo completed")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running DuckDB demo: {e}")
        return False

def generate_docs():
    """Generate dbt documentation"""
    print("\n=== Generating dbt Documentation ===")
    try:
        subprocess.check_call([sys.executable, "-m", "dbt", "docs", "generate", "--profiles-dir", "."])
        print("Documentation generated")
        
        # Serve the documentation
        print("Starting documentation server. Press Ctrl+C to stop.")
        subprocess.check_call([sys.executable, "-m", "dbt", "docs", "serve", "--profiles-dir", "."])
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error generating documentation: {e}")
        return False
    except KeyboardInterrupt:
        print("Documentation server stopped")
        return True

def main():
    """Main function to run the full pipeline"""
    start_time = time.time()
    
    # Make sure we're in the right directory
    os.chdir(Path(__file__).parent)
    
    print("=== Tesla Data Analysis Pipeline ===\n")
    
    # Get command line arguments
    args = sys.argv[1:]
    
    if len(args) == 0 or "all" in args:
        # Run everything
        run_csv_explorer()
        run_duckdb_demo()
        run_dbt()
        run_dbt_test()
        if "docs" in args or "all" in args:
            generate_docs()
    else:
        # Run specific components
        if "explore" in args:
            run_csv_explorer()
        if "demo" in args:
            run_duckdb_demo()
        if "dbt" in args:
            run_dbt()
        if "test" in args:
            run_dbt_test()
        if "docs" in args:
            generate_docs()
    
    end_time = time.time()
    print(f"\nPipeline completed in {end_time - start_time:.2f} seconds")

if __name__ == "__main__":
    main()
