-- =========================================================
-- MODULE 6: RFM SEGMENTATION ANALYSIS (FINAL VERSION)
-- =========================================================
WITH customer_base AS (
    SELECT 
        customer_id,
        MAX(invoice_date)              AS last_purchase_date,
        COUNT(DISTINCT invoice_no)     AS frequency,
        SUM(revenue)                   AS monetary
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
        NTILE(5) OVER (ORDER BY recency_days ASC)   AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC)      AS f_score,
        NTILE(5) OVER (ORDER BY monetary DESC)       AS m_score
    FROM recency_calc
),
rfm_segment AS (
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary,
        r_score,
        f_score,
        m_score,
        CASE
            WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2
                THEN 'Champions'
            WHEN r_score >= 4 AND f_score <= 2 AND m_score <= 2
                THEN 'Hibernating High Value'
            WHEN f_score <= 2 AND m_score <= 3
                THEN 'Loyal'
            WHEN r_score <= 2 AND f_score >= 4
                THEN 'Promising'
            WHEN r_score >= 4 AND f_score <= 3 AND m_score BETWEEN 3 AND 4
                THEN 'At Risk'
            ELSE 'Low Value'
        END AS customer_segment
    FROM rfm_scores
)
SELECT 
    customer_segment,
    COUNT(*)                                AS customer_count,
    ROUND(SUM(monetary), 2)                 AS total_revenue,
    ROUND(AVG(monetary), 2)                 AS avg_customer_value,
    ROUND(AVG(frequency), 1)                AS avg_order_frequency,
    ROUND(AVG(recency_days), 0)             AS avg_days_since_purchase,
    ROUND(
        SUM(monetary) * 100.0 /
        (SELECT SUM(revenue) FROM online_retail_clean), 2
    )                                       AS revenue_percentage
FROM rfm_segment
GROUP BY customer_segment
ORDER BY total_revenue DESC;