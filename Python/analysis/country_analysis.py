import pandas as pd

from db.connection import engine


def country_analysis() -> pd.DataFrame:
    query = """
        SELECT
            country,
            COUNT(DISTINCT customer_id) AS customers,
            COUNT(DISTINCT invoice_no) AS orders,
            SUM(quantity) AS units_sold,
            SUM(revenue) AS revenue
        FROM online_retail_clean
        GROUP BY country
        ORDER BY revenue DESC
    """

    df = pd.read_sql(query, engine)

    df["revenue"] = df["revenue"].astype(float)

    df["average_order_value"] = (
        df["revenue"] / df["orders"]
    )

    df["revenue_percentage"] = (
        df["revenue"] / df["revenue"].sum() * 100
    )

    return df