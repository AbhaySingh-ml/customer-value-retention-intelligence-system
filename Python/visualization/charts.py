from pathlib import Path
import sys

import matplotlib.pyplot as plt
import seaborn as sns

# Allow imports when running from the project root
PROJECT_ROOT = Path(__file__).resolve().parents[2]
PYTHON_DIR = PROJECT_ROOT / "python"

if str(PYTHON_DIR) not in sys.path:
    sys.path.insert(0, str(PYTHON_DIR))

from analysis.revenue_analysis import monthly_revenue
from analysis.rfm_analysis import rfm_analysis
from analysis.country_analysis import country_analysis


RESULTS_DIR = PROJECT_ROOT / "results"
CHARTS_DIR = RESULTS_DIR / "charts"

CHARTS_DIR.mkdir(parents=True, exist_ok=True)


def create_revenue_trend():
    df = monthly_revenue()

    plt.figure(figsize=(12, 6))
    sns.lineplot(
        data=df,
        x="month",
        y="revenue",
        marker="o"
    )

    plt.title("Monthly Revenue Trend")
    plt.xlabel("Month")
    plt.ylabel("Revenue")
    plt.xticks(rotation=45)
    plt.tight_layout()

    output = CHARTS_DIR / "monthly_revenue_trend.png"
    plt.savefig(output, dpi=150)
    plt.close()

    return output


def create_revenue_growth():
    df = monthly_revenue()

    if "revenue_growth_pct" not in df.columns:
        return None

    plt.figure(figsize=(12, 6))
    sns.barplot(
        data=df,
        x="month",
        y="revenue_growth_pct"
    )

    plt.title("Monthly Revenue Growth")
    plt.xlabel("Month")
    plt.ylabel("Growth (%)")
    plt.xticks(rotation=45)
    plt.tight_layout()

    output = CHARTS_DIR / "monthly_revenue_growth.png"
    plt.savefig(output, dpi=150)
    plt.close()

    return output


def create_rfm_segments():
    df = rfm_analysis()

    segment_counts = (
        df["customer_segment"]
        .value_counts()
        .reset_index()
    )

    segment_counts.columns = ["customer_segment", "customers"]

    plt.figure(figsize=(10, 6))
    sns.barplot(
        data=segment_counts,
        x="customers",
        y="customer_segment"
    )

    plt.title("Customer Distribution by RFM Segment")
    plt.xlabel("Customers")
    plt.ylabel("Customer Segment")
    plt.tight_layout()

    output = CHARTS_DIR / "rfm_customer_segments.png"
    plt.savefig(output, dpi=150)
    plt.close()

    return output


def create_rfm_revenue():
    df = rfm_analysis()

    segment_revenue = (
        df.groupby("customer_segment", as_index=False)["monetary"]
        .sum()
        .sort_values("monetary", ascending=False)
    )

    plt.figure(figsize=(10, 6))
    sns.barplot(
        data=segment_revenue,
        x="monetary",
        y="customer_segment"
    )

    plt.title("Revenue by RFM Segment")
    plt.xlabel("Revenue")
    plt.ylabel("Customer Segment")
    plt.tight_layout()

    output = CHARTS_DIR / "rfm_segment_revenue.png"
    plt.savefig(output, dpi=150)
    plt.close()

    return output


def create_country_revenue():
    df = country_analysis()

    top_countries = df.head(10).copy()

    plt.figure(figsize=(10, 6))
    sns.barplot(
        data=top_countries,
        x="revenue",
        y="country"
    )

    plt.title("Top 10 Countries by Revenue")
    plt.xlabel("Revenue")
    plt.ylabel("Country")
    plt.tight_layout()

    output = CHARTS_DIR / "top_countries_revenue.png"
    plt.savefig(output, dpi=150)
    plt.close()

    return output


def create_all_charts():
    charts = {
        "monthly_revenue_trend": create_revenue_trend(),
        "monthly_revenue_growth": create_revenue_growth(),
        "rfm_customer_segments": create_rfm_segments(),
        "rfm_segment_revenue": create_rfm_revenue(),
        "top_countries_revenue": create_country_revenue(),
    }

    return charts


if __name__ == "__main__":
    outputs = create_all_charts()

    for name, path in outputs.items():
        print(f"{name}: {path}")