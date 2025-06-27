-- Top 10 Tesla vehicles by investment score with market intelligence
select 
    vin,
    model,
    trim_name,
    year,
    price,
    country,
    city,
    market_tier,
    investment_score,
    market_position,
    price_vs_market_avg,
    price_premium_pct
from tesla_market_intelligence 
order by investment_score desc 
limit 10
