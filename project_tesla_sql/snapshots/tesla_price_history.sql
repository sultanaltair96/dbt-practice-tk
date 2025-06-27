{% snapshot tesla_price_history %}

{{
    config(
      target_schema='main',
      unique_key='vin',
      strategy='timestamp',
      updated_at='record_time_str',
    )
}}

select 
    vin,
    model,
    trim_name,
    year,
    price,
    country,
    record_time_str
from {{ ref('stg_tesla_vehicles') }}
where price is not null

{% endsnapshot %}
