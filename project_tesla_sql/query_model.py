import duckdb

# Connect to the database
conn = duckdb.connect('c:/Users/tanis/dbt-practice-tk/dbt-practice-tk/project_tesla/tesla.duckdb')

# Query the marts model
results = conn.execute("SELECT * FROM main.tesla_condition_analysis LIMIT 10").fetchall()

# Display results
for row in results:
    print(row)

# Close connection
conn.close()
