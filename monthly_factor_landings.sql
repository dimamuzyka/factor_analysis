select
     cast(date_trunc('month', day) as date) as month,
    'key_metrics' as fact_category,
    'landings' as metric,
     cast(sum(value) as int) as landings
from yc_hive.dev_derivative_exchange.exchange_bi_metrics
where day >= date('2024-01-01') and metric in ('exchange_landing')
group by 1, 2, 3
order by 1