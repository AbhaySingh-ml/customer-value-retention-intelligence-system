-- =========================================================
-- COUNTRY ANALYSIS
-- =========================================================
-- Objective:
-- Analyze revenue, customers, orders, and average order
-- value across countries.
--
-- Business questions:
-- 1. Which countries generate the most revenue?
-- 2. How many customers and orders does each country have?
-- 3. What is the average order value by country?
-- 4. How concentrated is revenue across countries?
-- =========================================================


-- =========================================================
-- ANALYSIS 1: COUNTRY PERFORMANCE
-- =========================================================

SELECT
    country,

    COUNT(DISTINCT customer_id) AS customer_count,

    COUNT(DISTINCT invoice_no) AS total_orders,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(revenue) / COUNT(DISTINCT invoice_no),
        2
    ) AS avg_order_value,

    ROUND(
        SUM(revenue) * 100.0 /
        (SELECT SUM(revenue)
         FROM online_retail_clean),
        2
    ) AS revenue_percentage

FROM online_retail_clean

GROUP BY country

ORDER BY total_revenue DESC;


-- =========================================================
-- ANALYSIS 2: CUMULATIVE REVENUE CONCENTRATION
-- =========================================================
-- Purpose:
-- Determine how quickly total business revenue is
-- concentrated across countries.
-- =========================================================

WITH country_revenue AS (

    SELECT
        country,
        SUM(revenue) AS total_revenue

    FROM online_retail_clean

    GROUP BY country
),

country_share AS (

    SELECT
        country,
        total_revenue,

        total_revenue * 100.0 /
        SUM(total_revenue) OVER () AS revenue_pct

    FROM country_revenue
)

SELECT
    country,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(revenue_pct, 2) AS revenue_pct,

    ROUND(
        SUM(revenue_pct) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_pct

FROM country_share

ORDER BY total_revenue DESC

LIMIT 10;
