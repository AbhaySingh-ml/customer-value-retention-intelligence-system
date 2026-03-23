-- =========================================================
-- RFM DIAGNOSTIC — Score Boundary Validation
-- =========================================================
-- Purpose:
-- Before writing segmentation logic, validate what each
-- NTILE score actually represents in terms of real values.
-- This query caught a critical inversion: r_score=5 was
-- mapping to customers who hadn't purchased in 280+ days,
-- meaning HIGH score = WORST recency (not best).
-- Fix applied: CASE logic uses low scores as good for
-- all three dimensions.
-- =========================================================

WITH customer_base AS (
    SELECT 
        customer_id,
        MAX(invoice_date)          AS last_purchase_date,
        COUNT(DISTINCT invoice_no) AS frequency,
        SUM(revenue)               AS monetary
    FROM online_retail_clean
    GROUP BY customer_id
),
recency_calc AS (
    SELECT *,
        EXTRACT(EPOCH FROM (
            (SELECT MAX(invoice_date) FROM online_retail_clean) - last_purchase_date
        )) / 86400 AS recency_days
    FROM customer_base
),
rfm_scores AS (
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency_days ASC)  AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC)     AS f_score,
        NTILE(5) OVER (ORDER BY monetary DESC)      AS m_score
    FROM recency_calc
)
-- Check what recency range each r_score bucket actually covers
SELECT
    r_score,
    COUNT(*)                         AS customer_count,
    ROUND(MIN(recency_days), 0)      AS min_days,
    ROUND(MAX(recency_days), 0)      AS max_days,
    ROUND(AVG(recency_days), 0)      AS avg_days
FROM rfm_scores
GROUP BY r_score
ORDER BY r_score ASC;

-- =========================================================
-- Full score combination breakdown (top 30)
-- =========================================================
SELECT 
    r_score,
    f_score,
    m_score,
    COUNT(*)                         AS customer_count,
    ROUND(AVG(recency_days), 0)      AS avg_recency,
    ROUND(AVG(frequency), 1)         AS avg_frequency,
    ROUND(AVG(monetary), 2)          AS avg_monetary
FROM rfm_scores
GROUP BY r_score, f_score, m_score
ORDER BY r_score DESC, f_score DESC, m_score DESC
LIMIT 30;


-- ## 3. Your Final Structure Should Look Like This
-- ```
-- .
-- ├── README.md
-- ├── dataset/
-- │   ├── Online Retail.xlsx
-- │   ├── online_retail.csv
-- │   └── online_retail_utf8.csv
-- ├── docs/
-- │   └── data_dictionary.md
-- ├── results/
-- │   ├── monthly_revenue.csv
-- │   ├── product_analysis.csv
-- │   ├── customer_intelligence.csv
-- │   ├── rfm_score_diagnostic.csv       ← renamed
-- │   ├── rfm_customer_level.csv
-- │   ├── country_analysis.csv
-- │   └── top_countries_cumulative.csv
-- └── sql/
--     ├── 01_create_table.sql
--     ├── 02_data_cleaning.sql
--     ├── 03_revenue_analysis.sql
--     ├── 04_product_analysis.sql
--     ├── 05_customer_intelligence.sql   ← fixed
--     ├── 06_rfm_analysis.sql
--     ├── 06b_rfm_diagnostic.sql         ← new
--     └── 07_country_analysis.sql