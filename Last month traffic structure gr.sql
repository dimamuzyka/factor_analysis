WITH monthly_data AS (
    SELECT 
        tp_domain,
        month,
        SUM(landings) AS landings,
        COALESCE(SUM(cpo_revenue + cpl_revenue) / NULLIF(SUM(landings), 0), 0) AS landing_value
    FROM yc_hive.dashboard_perfomance.slicer_v2_tp_fact
    WHERE product_line = 'Offer Walls'
        AND tp_country = 'Russia'
        AND tp_is_test = FALSE
    GROUP BY 1, 2
),
monthly_with_lag AS (
    SELECT 
        tp_domain,
        month,
        landings AS current_landings,
        landing_value,
        LAG(landings) OVER (PARTITION BY tp_domain ORDER BY month) AS landings_prev_month
    FROM monthly_data
)
SELECT 
    month,
    SUM(COALESCE(landings_prev_month, 0) * COALESCE(landing_value, 0)) AS old_weight_revenue
FROM monthly_with_lag
GROUP BY month
ORDER BY month;