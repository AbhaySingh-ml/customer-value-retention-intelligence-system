-- Method 1 — ⭐ Recommended (CTE + Window Function)

-- =========================================================
-- PRODUCT PERFORMANCE ANALYSIS
-- =========================================================
-- Objective:
-- Identify top revenue-generating products and their contribution
-- =========================================================

WITH product_revenue AS (
    SELECT 
        description AS product,
        SUM(revenue) AS total_revenue
    FROM online_retail_clean
    GROUP BY description
),

ranked_products AS (
    SELECT 
        product,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS rank,
        SUM(total_revenue) OVER () AS overall_revenue
    FROM product_revenue
)

SELECT 
    product,
    ROUND(total_revenue, 2) AS revenue,
    rank,
    ROUND((total_revenue * 100.0 / overall_revenue), 2) AS contribution_percentage
FROM ranked_products
ORDER BY revenue DESC
LIMIT 10;


-- Notes
-- - Uses CTE for clarity and modular design
-- - Uses RANK() to handle ties in revenue
-- - Uses SUM() OVER() to compute total revenue efficiently
-- - Avoids recalculating totals via subqueries (better performance)



-- Method 2 — Subquery Approach (Less Efficient)

SELECT 
    description AS product,
    ROUND(SUM(revenue), 2) AS revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS rank,
    ROUND(
        SUM(revenue) * 100.0 / 
        (SELECT SUM(revenue) FROM online_retail_clean),
        2
    ) AS contribution_percentage
FROM online_retail_clean
GROUP BY description
ORDER BY revenue DESC
LIMIT 10;


-- Notes
-- - Simpler to write but less efficient
-- - Total revenue recalculated for each row
-- - Not ideal for large datasets