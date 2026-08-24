import pandas as pd

from db.connection import engine


def monthly_revenue() -> pd.DataFrame:
    query = """
        SELECT
            DATE_TRUNC('month', invoice_date) AS month,
            SUM(revenue) AS revenue,
            COUNT(DISTINCT invoice_no) AS orders,
            COUNT(DISTINCT customer_id) AS customers
        FROM online_retail_clean
        GROUP BY 1
        ORDER BY 1
    """

    df = pd.read_sql(query, engine)

    df["revenue"] = df["revenue"].astype(float)
    df["average_order_value"] = df["revenue"] / df["orders"]

    df["growth_pct"] = (
        df["revenue"].pct_change() * 100
    )

    return df