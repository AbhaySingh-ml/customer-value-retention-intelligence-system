-- =========================================================
-- INSIGHTS:
-- - Revenue is highly volatile month-over-month
-- - Strong growth observed in March, May, and September
-- - Q4 shows peak performance followed by December decline
-- =========================================================


-- =========================================================
-- MONTHLY REVENUE ANALYSIS
-- =========================================================
-- Objective:
-- Track how revenue changes over time (month-wise)
--
-- Why this matters:
-- - Identifies trends (growth/decline)
-- - Detects seasonality
-- - Supports forecasting and planning
-- =========================================================

SELECT 
    DATE_TRUNC('month', invoice_date) AS month,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM online_retail_clean
GROUP BY month
ORDER BY month;


-- =========================================================
-- MONTH-OVER-MONTH GROWTH (USING LAG)
-- =========================================================
-- Objective:
-- Calculate how revenue grows or declines month-to-month
--
-- Why this matters:
-- - Measures business momentum
-- - Detects slowdown early
-- =========================================================

WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', invoice_date) AS month,
        SUM(revenue) AS total_revenue
    FROM online_retail_clean
    GROUP BY month
)

SELECT 
    month,
    ROUND(total_revenue, 2) AS revenue,
    
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY month)) 
        / LAG(total_revenue) OVER (ORDER BY month) * 100,
        2
    ) AS growth_percentage

FROM monthly_revenue
ORDER BY month;