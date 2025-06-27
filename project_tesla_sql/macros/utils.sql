{% macro date_diff_in_years(end_date, start_date) %}
    ((extract(year from {{ end_date }}) - extract(year from {{ start_date }})) + 
     (extract(month from {{ end_date }}) - extract(month from {{ start_date }})) / 12.0 + 
     (extract(day from {{ end_date }}) - extract(day from {{ start_date }})) / 365.0)
{% endmacro %}

{% macro clean_vin(vin_column) %}
    case
        when {{ vin_column }} is null then null
        when length({{ vin_column }}) < 10 then null
        else upper(regexp_replace({{ vin_column }}, '[^A-Za-z0-9]', ''))
    end
{% endmacro %}

{% macro price_category(price_column) %}
    case
        when {{ price_column }} is null then 'Unknown'
        when {{ price_column }} < 20000 then 'Budget (< 20K)'
        when {{ price_column }} < 30000 then 'Value (20K-30K)'
        when {{ price_column }} < 40000 then 'Mid-Range (30K-40K)'
        when {{ price_column }} < 50000 then 'Premium (40K-50K)'
        else 'Luxury (50K+)'
    end
{% endmacro %}
