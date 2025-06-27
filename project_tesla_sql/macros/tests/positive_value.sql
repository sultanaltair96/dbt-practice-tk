{% test positive_value(model, column_name) %}

with validation as (
    select
        {{ column_name }} as value_field
    from {{ model }}
    where {{ column_name }} is not null and {{ column_name }} <= 0
)

select *
from validation

{% endtest %}
