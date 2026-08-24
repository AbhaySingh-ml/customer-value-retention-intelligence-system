import pandas as pd

from db.connection import engine


def rfm_analysis() -> pd.DataFrame:
    query = """
        WITH customer_base AS (
            SELECT
                customer_id,
                MAX(invoice_date) AS last_purchase_date,
                COUNT(DISTINCT invoice_no) AS frequency,
                SUM(revenue) AS monetary
            FROM online_retail_clean
            GROUP BY customer_id
        ),

        recency_calc AS (
            SELECT
                *,
                EXTRACT(
                    EPOCH FROM (
                        (SELECT MAX(invoice_date)
                         FROM online_retail_clean)
                        - last_purchase_date
                    )
                ) / 86400 AS recency_days
            FROM customer_base
        ),

        rfm_scores AS (
            SELECT
                *,
                NTILE(5) OVER (
                    ORDER BY recency_days ASC
                ) AS r_score,

                NTILE(5) OVER (
                    ORDER BY frequency DESC
                ) AS f_score,

                NTILE(5) OVER (
                    ORDER BY monetary DESC
                ) AS m_score

            FROM recency_calc
        )

        SELECT
            customer_id,
            recency_days,
            frequency,
            monetary,
            r_score,
            f_score,
            m_score,

            CASE
                WHEN r_score <= 2
                     AND f_score <= 2
                     AND m_score <= 2
                    THEN 'Champions'

                WHEN r_score >= 4
                     AND f_score <= 2
                     AND m_score <= 2
                    THEN 'Hibernating High Value'

                WHEN f_score <= 2
                     AND m_score <= 3
                    THEN 'Loyal'

                WHEN r_score <= 2
                     AND f_score >= 4
                    THEN 'Promising'

                WHEN r_score >= 4
                     AND f_score <= 3
                     AND m_score BETWEEN 3 AND 4
                    THEN 'At Risk'

                ELSE 'Low Value'
            END AS customer_segment

        FROM rfm_scores
    """

    return pd.read_sql(query, engine)