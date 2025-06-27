import duckdb

# Connect to the database
conn = duckdb.connect('c:/Users/tanis/dbt-practice-tk/dbt-practice-tk/project_tesla/tesla_project.duckdb')

# Query with filtering and sorting
query = """
SELECT analysis_type, dimension, total_vehicles, accident_percentage 
FROM main.tesla_condition_analysis
WHERE analysis_type = 'Accident Stats by Model'
ORDER BY accident_percentage DESC
"""

print("Models ranked by accident percentage:")
results = conn.execute(query).fetchall()
for row in results:
    print(f"{row[1]}: {row[3]}% of {row[2]} vehicles")

# Another query - calculate average statistics by analysis type
query2 = """
SELECT analysis_type, 
       COUNT(*) as count, 
       AVG(total_vehicles) as avg_vehicles_per_group
FROM main.tesla_condition_analysis
GROUP BY analysis_type
"""

print("\nSummary statistics:")
results = conn.execute(query2).fetchall()
for row in results:
    print(f"{row[0]}: {row[1]} groups with average of {int(row[2])} vehicles per group")

# Close connection
conn.close()
