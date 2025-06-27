import os
from pathlib import Path
import pandas as pd

# Model configuration
def model(dbt, session):
    """
    This is a dbt Python model for basic Tesla data transformation.
    
    It will be materialized as a table in the DuckDB database.
    """
    # Configure model materialization
    dbt.config(
        materialized="table"
    )
    
    # Get the raw CSV file path
    csv_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'tesla_results.csv')
    
    # Read the CSV file
    df = pd.read_csv(csv_path)
    
    # Print dataset information for debugging
    print(f"Loaded CSV with {len(df)} rows and {len(df.columns)} columns")
    print(f"Columns: {', '.join(df.columns)}")
    
    # Basic data cleaning
    # 1. Convert column names to lowercase and replace spaces with underscores
    df.columns = df.columns.str.lower().str.replace(' ', '_')
    
    # 2. Handle missing values (if any)
    df = df.fillna(0)  # Replace NaN with 0 (adjust based on your needs)
    
    # 3. Remove duplicates if any
    df = df.drop_duplicates()
    
    # 4. Add a processed timestamp column
    from datetime import datetime
    df['processed_at'] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    return df
