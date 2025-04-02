WITH revenue_data AS (
    SELECT
        adv_domain AS domain,
        month,
        SUM(cpo_revenue + cpl_revenue) AS total_revenue,
        SUM(clicks) AS total_clicks
    FROM yc_hive.dashboard_perfomance.slicer_v2_adv_fact
    WHERE product_line = 'Offer Walls'
      AND adv_country = 'Russia'
      AND adv_is_test = false
      AND product_mechanic = 'Exchange'
      AND month >= DATE '2024-01-01'
    GROUP BY 1,2
),
top_advertisers AS (
    SELECT
        domain,
        month,
        total_revenue,
        total_clicks,
        LAG(total_revenue) OVER (PARTITION BY domain ORDER BY month) AS prev_total_revenue,
        LAG(total_clicks) OVER (PARTITION BY domain ORDER BY month) AS prev_total_clicks
    FROM revenue_data
),
filtered_top AS (
    SELECT * FROM top_advertisers WHERE prev_total_revenue > 5000000
)
SELECT
    month,
    SUM(((total_revenue / NULLIF(total_clicks, 0)) * total_clicks) - ((prev_total_revenue / NULLIF(prev_total_clicks, 0)) * total_clicks)) AS total_igr_change
FROM filtered_top
GROUP BY month
ORDER BY month