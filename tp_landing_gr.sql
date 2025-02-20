with revenue as (
    select month, source_site_id, sum(revenue_split) as revenue_split
    from yc_hive.datamart_perfomance.revenue_split_by_bid
    where month >= date('2024-01-01')
    group by month, source_site_id

    union all

    select month, source_site_id, sum(revenue_split) as revenue_split
    from yc_hive.datamart_perfomance.cpl_revenue_by_bid
    where month >= date('2024-01-01')
    group by month, source_site_id
)
select month, cast(sum(revenue_split) as int) as revenue
from revenue
where source_site_id in (
    select id from yc_hive.masterdata_general.sites_v2 where partner_type = '{traffic_provider}'
)
group by month
order by month;