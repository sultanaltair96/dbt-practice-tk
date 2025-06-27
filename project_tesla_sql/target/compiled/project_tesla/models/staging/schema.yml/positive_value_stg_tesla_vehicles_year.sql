

with validation as (
    select
        year as value_field
    from "tesla"."main"."stg_tesla_vehicles"
    where year is not null and year <= 0
)

select *
from validation

