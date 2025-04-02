select 
    month, 
    sum(cpo_revenue + cpl_revenue) as revenue
from yc_hive.dashboard_perfomance.slicer_v2_tp_fact
where product_line = 'Offer Walls'
    and month >= date'2024-01-01'
    and tp_partner_type = '{advertiser}'
        and product_mechanic = 'Exchange'
    and tp_country = 'Russia'
    and tp_is_test = false
group by 1
order by 1