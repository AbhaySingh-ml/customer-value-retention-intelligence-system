from pathlib import Path

import sys

sys.path.insert(0, "python")

from analysis.customer_analysis import (
    load_customer_data,
    customer_summary,
    add_customer_metrics,
)
from analysis.revenue_analysis import monthly_revenue
from analysis.rfm_analysis import rfm_analysis
from analysis.country_analysis import country_analysis


PROJECT_ROOT = Path(__file__).resolve().parents[2]
REPORT_PATH = PROJECT_ROOT / "docs" / "customer_value_retention_report.md"


def generate_report():
    df = load_customer_data()

    summary = customer_summary(df)
    customer_metrics = add_customer_metrics(summary)

    revenue = monthly_revenue()
    rfm = rfm_analysis()
    countries = country_analysis()

    total_revenue = float(revenue["revenue"].sum())
    average_monthly_revenue = float(revenue["revenue"].mean())

    segment_counts = rfm["customer_segment"].value_counts()

    top_countries = countries.head(10)

    report = f"""# Customer Value & Retention Intelligence Report

## 1. Executive Summary

This project analyzes customer purchasing behavior using PostgreSQL, Python, Pandas, and customer-level RFM analysis.

The workflow transforms raw transactional data into a structured customer intelligence pipeline covering:

- Data cleaning and validation
- Revenue analysis
- Customer-level behavioral metrics
- RFM-style customer segmentation
- Geographic revenue analysis
- Retention and re-engagement opportunities

The objective is to identify where revenue is generated, which customer groups are most valuable, and which customer segments may require retention attention.

---

## 2. Dataset Overview

### Clean Dataset

- Cleaned transaction rows: 397,880
- Unique customers: {customer_metrics["customer_id"].nunique():,}
- Countries analyzed: {countries["country"].nunique()}
- Months analyzed: {len(revenue)}

The cleaned dataset is stored in PostgreSQL and serves as the analytical source for the Python analysis layer.

---

## 3. Revenue Analysis

Monthly revenue was calculated from the cleaned transactional dataset.

- Total revenue: {total_revenue:,.2f}
- Average monthly revenue: {average_monthly_revenue:,.2f}
- Months analyzed: {len(revenue)}

The monthly revenue trend is available in:

`results/charts/monthly_revenue_trend.png`

The revenue series shows substantial variation across the analyzed period, with particularly strong revenue performance toward the later months of the dataset.

---

## 4. Customer Segmentation

Customers were segmented using RFM-style behavioral analysis based on customer purchasing activity.

### Segment Distribution

"""

    segment_order = [
        "Low Value",
        "Champions",
        "Loyal",
        "Promising",
        "At Risk",
        "Hibernating High Value",
    ]

    total_customers = len(rfm)

    for segment in segment_order:
        count = int(segment_counts.get(segment, 0))
        percentage = count * 100 / total_customers
        report += f"- **{segment}:** {count:,} customers ({percentage:.2f}%)\n"

    report += f"""

---

## 5. Customer Value

Customer-level metrics include:

- Total revenue
- Total orders
- Average order value
- Active months
- Orders per active month
- Customer lifetime duration

These metrics provide a behavioral view of customer value rather than relying only on total revenue.

The customer-level analysis produced {len(customer_metrics):,} customer records.

---

## 6. Geographic Analysis

The following countries generated the highest revenue:

"""

    for _, row in top_countries.iterrows():
        report += (
            f"- **{row['country']}:** "
            f"{row['revenue']:,.2f} revenue, "
            f"{int(row['customers']):,} customers, "
            f"{int(row['orders']):,} orders\n"
        )

    report += """

---

## 7. Business Findings & Recommendations

### Finding 1 — Revenue is highly concentrated in the United Kingdom

The United Kingdom generated approximately 7.31M in revenue, making it by far the dominant geographic market in the dataset.

**Recommendation:** Protect the existing UK customer base through strong retention and service quality while evaluating opportunities to diversify revenue across other markets.

### Finding 2 — Low Value customers represent the largest customer segment

2,091 customers (48.20%) are classified as Low Value.

**Recommendation:** Investigate whether these customers can be converted into repeat purchasers through targeted offers, product recommendations, and re-engagement campaigns.

### Finding 3 — Champions represent a significant high-value segment

961 customers (22.15%) are classified as Champions.

**Recommendation:** Prioritize retention of these customers through loyalty initiatives, personalized offers, and proactive engagement.

### Finding 4 — At Risk and Hibernating High Value customers represent retention opportunities

284 customers are classified as At Risk, while 187 customers are classified as Hibernating High Value.

**Recommendation:** Prioritize these segments for targeted win-back campaigns because inactivity among previously valuable customers can represent a meaningful retention opportunity.

### Finding 5 — Geographic performance is uneven

Revenue is heavily concentrated in a small number of markets, with the United Kingdom accounting for the majority of recorded revenue.

**Recommendation:** Use country-level performance to prioritize market-specific retention and expansion strategies rather than applying a uniform international strategy.

---

## 8. Visualizations

Generated visualizations include:

- Monthly revenue trend
- RFM customer segment distribution
- Revenue by RFM segment
- Top countries by revenue

Visualization files are stored under:

`results/charts/`

---

## 9. Technical Stack

- PostgreSQL
- SQL
- Python
- Pandas
- SQLAlchemy
- psycopg2
- Matplotlib
- Seaborn
- python-dotenv

---

## 10. Project Outcome

The project transforms raw transactional data into a structured customer intelligence workflow:

**Data Cleaning → SQL Analysis → Customer-Level Metrics → RFM Segmentation → Revenue Analysis → Geographic Analysis → Business Insights**

The resulting analytical outputs can support customer segmentation, retention analysis, revenue monitoring, and targeted business decision-making.
"""

    REPORT_PATH.write_text(report, encoding="utf-8")

    print(f"Report generated: {{REPORT_PATH}}")


if __name__ == "__main__":
    generate_report()