import pandas as pd
import os
import numpy as np
from datetime import datetime, timedelta

# This is a dbt Python model that depends on the tesla_transform model
def model(dbt, session):
    """
    This is a dbt Python model for advanced Tesla data analysis.
    
    It depends on the tesla_transform model and will perform more complex
    transformations and analytics on the data.
    """
    # Configure model materialization and dependencies
    dbt.config(
        materialized="table",
        packages=["pandas", "numpy"]
    )
    
    # Get the transformed data from the tesla_transform model
    # This uses dbt's ref function to create a dependency on the tesla_transform model
    df = dbt.ref("tesla_transform")
    
    # Print data information for debugging
    print(f"Received dataframe with {len(df)} rows and {len(df.columns)} columns")
    
    # Advanced transformations (adapt these based on your actual CSV structure)
    try:
        # 1. Calculate metrics (these are examples - adjust for your actual data)
        
        # Assuming your CSV has date and numeric columns like 'price' or 'value'
        # If your DataFrame has a date column, ensure it's in datetime format
        if 'date' in df.columns:
            df['date'] = pd.to_datetime(df['date'])
            
            # Sort by date
            df = df.sort_values('date')
            
            # Calculate day-over-day changes
            if 'price' in df.columns:
                df['price_change'] = df['price'].diff()
                df['price_pct_change'] = df['price'].pct_change() * 100
                
                # Calculate moving averages
                df['7d_ma'] = df['price'].rolling(window=7).mean()
                df['30d_ma'] = df['price'].rolling(window=30).mean()
        
        # 2. Create aggregated summaries
        # Example: Monthly aggregation
        if 'date' in df.columns:
            # Extract month and year
            df['year_month'] = df['date'].dt.strftime('%Y-%m')
            
            # Group by month and calculate monthly metrics
            monthly_df = df.groupby('year_month').agg({
                'price': ['mean', 'min', 'max', 'std'] if 'price' in df.columns else [],
                'volume': ['sum', 'mean'] if 'volume' in df.columns else [],
                # Add more aggregations based on your columns
            })
            
            # Flatten the column structure
            monthly_df.columns = ['_'.join(col).strip() for col in monthly_df.columns.values]
            monthly_df = monthly_df.reset_index()
            
            # Add monthly data as new columns to original dataframe
            df = df.merge(monthly_df, on='year_month', how='left')
        
        # 3. Identify outliers
        if 'price' in df.columns:
            mean = df['price'].mean()
            std = df['price'].std()
            df['is_outlier'] = np.abs(df['price'] - mean) > (3 * std)
            
        # 4. Add analysis timestamp
        df['analysis_timestamp'] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
    except Exception as e:
        print(f"Error during analysis: {e}")
        # In case of error, still return the original dataframe
        df['error_in_analysis'] = str(e)
    
    return df
