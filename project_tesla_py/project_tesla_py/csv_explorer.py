"""
CSV Explorer Utility for Tesla Data Analysis

This script helps analyze the structure of your CSV file to aid in building
proper transformations in your dbt Python models.
"""
import pandas as pd
import os
import sys
from pathlib import Path

def explore_csv(file_path):
    """Analyze the structure of a CSV file and print useful information"""
    try:
        # Read the CSV file
        print(f"Reading CSV file: {file_path}")
        df = pd.read_csv(file_path)
        
        # Basic info
        print("\n== BASIC INFORMATION ==")
        print(f"Rows: {len(df)}")
        print(f"Columns: {len(df.columns)}")
        print(f"Memory usage: {df.memory_usage(deep=True).sum() / 1024 / 1024:.2f} MB")
        
        # Columns
        print("\n== COLUMNS ==")
        for col in df.columns:
            print(f"- {col} ({df[col].dtype})")
        
        # Data sample
        print("\n== DATA SAMPLE (5 rows) ==")
        print(df.head(5))
        
        # Column statistics
        print("\n== COLUMN STATISTICS ==")
        numeric_cols = df.select_dtypes(include=['number']).columns.tolist()
        if numeric_cols:
            print("\nNumeric columns:")
            for col in numeric_cols:
                print(f"- {col}:")
                print(f"  Min: {df[col].min()}")
                print(f"  Max: {df[col].max()}")
                print(f"  Mean: {df[col].mean()}")
                print(f"  Missing: {df[col].isna().sum()} ({df[col].isna().sum() / len(df) * 100:.2f}%)")
        
        date_cols = []
        for col in df.columns:
            # Try to infer if column might contain dates
            if 'date' in col.lower() or 'time' in col.lower():
                date_cols.append(col)
        
        if date_cols:
            print("\nPotential date columns:")
            for col in date_cols:
                print(f"- {col}")
                print(f"  First value: {df[col].iloc[0]}")
                print(f"  Last value: {df[col].iloc[-1]}")
        
        # Missing values
        print("\n== MISSING VALUES ==")
        missing = df.isna().sum()
        missing = missing[missing > 0]
        if len(missing) > 0:
            for col, count in missing.items():
                print(f"- {col}: {count} missing values ({count / len(df) * 100:.2f}%)")
        else:
            print("No missing values found")
            
        # Suggest potential analysis
        print("\n== SUGGESTIONS FOR ANALYSIS ==")
        if len(date_cols) > 0:
            print("- Time series analysis on date columns")
            print("- Aggregations by day/week/month")
        if len(numeric_cols) > 0:
            print("- Statistical analysis on numeric columns")
            print("- Correlation analysis between numeric fields")
        
        return True
    except Exception as e:
        print(f"Error exploring CSV: {e}")
        return False

if __name__ == "__main__":
    # Use command line argument or default to the project directory
    if len(sys.argv) > 1:
        csv_path = sys.argv[1]
    else:
        # Default to tesla_results.csv in the project directory
        current_dir = os.path.dirname(os.path.abspath(__file__))
        csv_path = os.path.join(current_dir, "tesla_results.csv")
    
    # Explore the CSV
    explore_csv(csv_path)
