import pandas as pd

from db.connection import engine


def load_customer_data() -> pd.DataFrame:
    query = """
        SELECT
            customer_id,
            invoice_no,
            invoice_date,
            quantity,
            unit_price,
            revenue,
            country
        FROM online_retail_clean
        WHERE customer_id IS NOT NULL
    """

    return pd.read_sql(query, engine)


def customer_summary(df: pd.DataFrame) -> pd.DataFrame:
    summary = (
        df.groupby("customer_id")
        .agg(
            total_orders=("invoice_no", "nunique"),
            total_revenue=("revenue", "sum"),
            total_items=("quantity", "sum"),
            first_purchase=("invoice_date", "min"),
            last_purchase=("invoice_date", "max"),
        )
        .reset_index()
    )

    summary["customer_lifetime_days"] = (
        summary["last_purchase"] - summary["first_purchase"]
    ).dt.days

    return summary


# def add_customer_metrics(df: pd.DataFrame) -> pd.DataFrame:
#     df = df.copy()

#     df["average_order_value"] = (
#         df["total_revenue"] / df["total_orders"]
#     )

#     df["purchase_frequency"] = (
#         df["total_orders"] / (df["customer_lifetime_days"] + 1)
#     )

#     return df


def add_customer_metrics(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()

    df["average_order_value"] = (
        df["total_revenue"] / df["total_orders"]
    )

    df["active_months"] = (
        df["customer_lifetime_days"] / 30.44
    ).clip(lower=1)

    df["orders_per_active_month"] = (
        df["total_orders"] / df["active_months"]
    )

    return df