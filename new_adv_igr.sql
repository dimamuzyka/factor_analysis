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
      and product_mechanic = 'Exchange'
      and month >= date'2024-01-01'
    GROUP BY 1,2
    HAVING SUM(cpo_revenue + cpl_revenue) > 10000
),
ranked_data AS (
    SELECT
        domain,
        month,
        total_revenue,
        total_clicks,
        LAG(total_revenue) OVER (PARTITION BY domain ORDER BY month) AS prev_total_revenue
    FROM revenue_data
)
SELECT
    month,
    sum((total_revenue / NULLIF(total_clicks, 0) - 20) * total_clicks) AS igr
FROM ranked_data
WHERE prev_total_revenue IS NULL
group by 1