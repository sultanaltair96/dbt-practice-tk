# Tesla Data Analysis Project Documentation

## Overview
This dbt project analyzes Tesla vehicle data, focusing on pricing, ownership patterns, and vehicle conditions.

## Data Models

### Source Data
- **tesla_results**: Raw CSV data containing Tesla vehicle information

### Staging Models
- **stg_tesla_vehicles**: Cleaned and standardized Tesla vehicle data

### Marts Models
1. **tesla_analysis**: Basic analysis of Tesla vehicles by country and model
2. **tesla_vehicles_incremental**: Incremental model that processes only new data
3. **tesla_price_trends**: Analysis of price trends using window functions
4. **tesla_condition_analysis**: Analysis of vehicle conditions and accident rates
5. **tesla_ownership_analysis**: Analysis of ownership patterns by price category

### Snapshots
- **tesla_price_history**: Tracks price changes over time (SCD Type 2)

## Key Macros
- **date_diff_in_years**: Calculates difference between dates in years
- **clean_vin**: Standardizes VIN format
- **price_category**: Categorizes vehicles by price range

## Testing Strategy
- Standard tests: not_null, unique
- Custom tests: positive_value

## Sample Analyses
- **top_value_vehicles**: Identifies the most valuable vehicles in inventory

## Model Relationships
```
seeds/tesla_results.csv
        |
        v
stg_tesla_vehicles
        |
        +-----------------+------------------+-------------------+---------------+
        |                 |                  |                   |               |
        v                 v                  v                   v               v
tesla_analysis    tesla_price_trends  tesla_condition_analysis  tesla_ownership_analysis  tesla_vehicles_incremental
```

## How to Use
1. Run `dbt seed` to load data
2. Run `dbt run` to create all models
3. Run `dbt test` to validate data quality
4. Run `dbt docs generate` to create documentation
5. Run `dbt docs serve` to view documentation locally
