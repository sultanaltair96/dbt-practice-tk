"""
This script demonstrates how to use DuckDB with the Tesla data CSV file.
It provides functions to load the data and run simple transformations.
"""
import os
import pandas as pd
import duckdb

def init_duckdb():
    """Initialize a DuckDB connection and return the connection object"""
    # Create or connect to a DuckDB database file
    conn = duckdb.connect('tesla_data.duckdb')
    return conn

def load_tesla_data(conn, csv_path):
    """Load the Tesla CSV data into DuckDB"""
    try:
        # Create a table from the CSV file
        conn.execute(f"""
            CREATE TABLE IF NOT EXISTS tesla_raw AS 
            SELECT * FROM read_csv_auto('{csv_path}')
        """)
        
        # Get the row count to verify loading
        result = conn.execute("SELECT COUNT(*) FROM tesla_raw").fetchone()
        print(f"Successfully loaded {result[0]} rows into tesla_raw table")
        
        # Get column names to help with further analysis
        columns = conn.execute("SELECT * FROM tesla_raw LIMIT 0").df().columns.tolist()
        print(f"Columns in tesla_raw: {', '.join(columns)}")
        
        return True
    except Exception as e:
        print(f"Error loading Tesla data: {e}")
        return False

def sample_transformations(conn):
    """Run some sample transformations on the Tesla data"""
    try:
        # These are placeholder queries - modify based on your actual CSV structure
        
        # Example 1: Daily summary statistics
        conn.execute("""
            CREATE OR REPLACE TABLE tesla_daily_summary AS
            SELECT 
                -- Modify these column names based on your actual data
                date_column as date,
                AVG(numeric_column) as avg_value,
                MAX(numeric_column) as max_value,
                MIN(numeric_column) as min_value,
                COUNT(*) as record_count
            FROM tesla_raw
            GROUP BY date_column
            ORDER BY date_column
        """)
        
        # Example 2: Moving averages
        conn.execute("""
            CREATE OR REPLACE TABLE tesla_moving_avgs AS
            SELECT 
                date_column as date,
                numeric_column as value,
                AVG(numeric_column) OVER (
                    ORDER BY date_column 
                    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
                ) as moving_avg_7day
            FROM tesla_raw
            ORDER BY date_column
        """)
        
        print("Sample transformations completed successfully")
        return True
    except Exception as e:
        print(f"Error during transformations: {e}")
        return False

def export_results(conn, table_name, output_path):
    """Export results from a DuckDB table to a CSV file"""
    try:
        # Export the table to a CSV file
        conn.execute(f"""
            COPY {table_name} TO '{output_path}' (FORMAT CSV, HEADER)
        """)
        print(f"Successfully exported {table_name} to {output_path}")
        return True
    except Exception as e:
        print(f"Error exporting {table_name}: {e}")
        return False

if __name__ == "__main__":
    # Set up paths
    current_dir = os.path.dirname(os.path.abspath(__file__))
    csv_path = os.path.join(current_dir, "tesla_results.csv")
    
    # Initialize DuckDB
    conn = init_duckdb()
    
    # Load the data
    if load_tesla_data(conn, csv_path):
        # Run transformations
        if sample_transformations(conn):
            # Export results
            export_results(conn, "tesla_daily_summary", "tesla_daily_summary.csv")
            export_results(conn, "tesla_moving_avgs", "tesla_moving_avgs.csv")
    
    # Close the connection
    conn.close()
    
    print("Processing complete")
