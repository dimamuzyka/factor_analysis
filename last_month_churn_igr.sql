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
    HAVING SUM(cpo_revenue + cpl_revenue) > 10000
),
ranked_data AS (
    SELECT
        domain,
        month,
        total_revenue,
        total_clicks,
        LEAD(total_revenue) OVER (PARTITION BY domain ORDER BY month) AS next_total_revenue
    FROM revenue_data
)
SELECT
    month,
    SUM((total_revenue / NULLIF(total_clicks, 0) - 20) * total_clicks) AS igr_churned
FROM ranked_data
WHERE next_total_revenue IS NULL
GROUP BY 1
