select
    month,
    'gr_by_traffic_type' as fact_category,
    'tp_landing_gr' as metric,
    cast(sum(cpo_revenue + cpl_revenue) as int) as revenue
from yc_hive.dashboard_perfomance.slicer_v2_tp_fact
where tp_partner_type = '{traffic_provider}'
group by 1
order by 1