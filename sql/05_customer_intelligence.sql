-- =========================================================
-- CUSTOMER INTELLIGENCE ANALYSIS
-- =========================================================
-- Objective:
-- Aggregate customer-level behavior:
-- - Total spend
-- - Purchase frequency
-- - Average order value
--
-- Why this matters:
-- Foundation for segmentation (RFM, CLV, churn)
-- =========================================================

WITH customer_metrics AS (

    SELECT 
        customer_id,

        -- Total money spent by customer
        ROUND(SUM(revenue), 2) AS total_spent,

        -- Number of unique orders (frequency)
        COUNT(DISTINCT invoice_no) AS order_count,

        -- Average order value
        ROUND(SUM(revenue) / COUNT(DISTINCT invoice_no), 2) AS avg_order_value

    FROM online_retail_clean
    GROUP BY customer_id
)

SELECT *
FROM customer_metrics
ORDER BY total_spent DESC
LIMIT 10;


-- =========================================================
-- TOP CUSTOMERS (USING NTILE)
-- =========================================================
-- Objective:
-- Segment customers based on total spend
-- =========================================================

WITH customer_metrics AS (

    SELECT 
        customer_id,
        SUM(revenue) AS total_spent
    FROM online_retail_clean
    GROUP BY customer_id
),

ranked_customers AS (

    SELECT 
        customer_id,
        total_spent,
        NTILE(10) OVER (ORDER BY total_spent DESC) AS customer_segment
    FROM customer_metrics
)

SELECT *
FROM ranked_customers
WHERE customer_segment = 1;


-- =========================================================
-- REVENUE CONTRIBUTION OF TOP CUSTOMERS
-- =========================================================

WITH customer_metrics AS (

    SELECT 
        customer_id,
        SUM(revenue) AS total_spent
    FROM online_retail_clean
    GROUP BY customer_id
),

ranked_customers AS (

    SELECT 
        customer_id,
        total_spent,
        NTILE(10) OVER (ORDER BY total_spent DESC) AS segment
    FROM customer_metrics
)

SELECT 
    ROUND(SUM(total_spent), 2) AS top_10_revenue,
    ROUND(
        SUM(total_spent) * 100.0 / 
        (SELECT SUM(revenue) FROM online_retail_clean),
        2
    ) AS contribution_percentage
FROM ranked_customers
WHERE segment = 1;