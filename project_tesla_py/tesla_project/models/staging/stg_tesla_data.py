# models/staging/stg_tesla_data.py

def model(dbt, session):
    dbt.config(materialized="table")
    

    df = session.table("tesla_results")


    return df
