-- Demonstration of join effects: Show how individual vehicles compare to both regional and model averages
select 
    model,
    trim_name,
    country,
    city,
    count(*) as vehicles_in_analysis,
    round(avg(price), 0) as individual_avg_price,
    round(avg(city_avg_price), 0) as regional_market_avg,
    round(avg(avg_model_price), 0) as model_type_avg,
    round(avg(price_vs_market_avg), 0) as avg_premium_vs_regional,
    round(avg(price_vs_model_avg), 0) as avg_premium_vs_model,
    string_agg(distinct market_tier, ', ') as market_tiers,
    string_agg(distinct availability_tier, ', ') as model_rarity
from tesla_market_intelligence 
where city_avg_price is not null and avg_model_price is not null
group by model, trim_name, country, city
having count(*) >= 2
order by avg(investment_score) desc
limit 15
