import polars as pl

def model(dbt, session):
    dbt.config(materialized="table")

    # Get the DuckDB relation as a PyRelation object
    source = dbt.ref("stg_tesla_data")

    # Convert to a Polars dataframe
    df = source.pl()  # This returns a Polars DataFrame

    # Select specific columns using Polars
    df = df.select([
        "trim_name",
        "city",
        "year"
    ])

    return df
