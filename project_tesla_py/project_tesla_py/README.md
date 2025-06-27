# Tesla Data Analysis with dbt and DuckDB

This project demonstrates how to use dbt with Python models and DuckDB for local data processing and analysis of Tesla data.

## Project Overview

This project sets up a data transformation pipeline using:

- **DuckDB**: A lightweight, in-process analytical database
- **dbt (data build tool)**: For orchestrating and managing data transformations
- **Python**: For all data transformations instead of SQL

## Getting Started

### Prerequisites

- Python 3.8+
- pip package manager

### Installation

1. Install required packages:

```bash
pip install -r requirements.txt
```

2. Configure dbt profile:

The profiles.yml file is already set up to use DuckDB. Make sure it's in the correct location or set the `--profiles-dir` flag when running dbt commands.

### Running the Project

1. Set up your environment:

```bash
python setup.py
```

2. Explore your CSV data structure:

```bash
python csv_explorer.py
```

3. Run the complete pipeline:

```bash
python run_pipeline.py all
```

Or run specific components:

```bash
python run_pipeline.py explore  # Run just the CSV explorer
python run_pipeline.py demo     # Run just the DuckDB demo
python run_pipeline.py dbt      # Run just the dbt models
python run_pipeline.py test     # Run just the dbt tests
python run_pipeline.py docs     # Generate and serve documentation
```

4. Alternatively, run dbt commands directly:

```bash
dbt run --profiles-dir .
dbt test --profiles-dir .
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
```

## Project Structure

- `models/`: Contains Python models for data transformation
  - `tesla_transform.py`: Basic data cleaning and transformation
  - `tesla_analysis.py`: Advanced analytics on the transformed data
  - `sources.yml`: Defines the data sources (CSV file)
  - `schema.yml`: Defines the model schemas

- `duckdb_demo.py`: A standalone script to demonstrate DuckDB functionality
- `csv_explorer.py`: A utility to analyze your CSV file structure
- `setup.py`: A script to set up your environment and install dependencies
- `run_pipeline.py`: A script to run the entire ETL pipeline

## Python Transformation Workflow

1. Raw data is loaded from the CSV file using pandas
2. Initial transformations are applied in `tesla_transform.py`
3. Advanced analytics are performed in `tesla_analysis.py`
4. Results are materialized as tables in DuckDB

## Direct DuckDB Usage

You can also interact with the data directly using the `duckdb_demo.py` script:

```bash
python duckdb_demo.py
```

This will:
1. Load the CSV data into DuckDB
2. Perform sample transformations
3. Export results to CSV files

## Customization

To adapt this project to your specific needs:

1. Update the transformation logic in the Python models based on your CSV structure
2. Modify the dbt_project.yml configuration as needed
3. Add additional Python models for more complex transformations
