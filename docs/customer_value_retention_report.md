# Customer Value & Retention Intelligence Report

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
- Unique customers: 4,338
- Countries analyzed: 37
- Months analyzed: 13

The cleaned dataset is stored in PostgreSQL and serves as the analytical source for the Python analysis layer.

---

## 3. Revenue Analysis

Monthly revenue was calculated from the cleaned transactional dataset.

- Total revenue: 8,911,407.90
- Average monthly revenue: 685,492.92
- Months analyzed: 13

The monthly revenue trend is available in:

`results/charts/monthly_revenue_trend.png`

The revenue series shows substantial variation across the analyzed period, with particularly strong revenue performance toward the later months of the dataset.

---

## 4. Customer Segmentation

Customers were segmented using RFM-style behavioral analysis based on customer purchasing activity.

### Segment Distribution

- **Low Value:** 2,091 customers (48.20%)
- **Champions:** 961 customers (22.15%)
- **Loyal:** 505 customers (11.64%)
- **Promising:** 310 customers (7.15%)
- **At Risk:** 284 customers (6.55%)
- **Hibernating High Value:** 187 customers (4.31%)


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

The customer-level analysis produced 4,338 customer records.

---

## 6. Geographic Analysis

The following countries generated the highest revenue:

- **United Kingdom:** 7,308,391.55 revenue, 3,920 customers, 16,646 orders
- **Netherlands:** 285,446.34 revenue, 9 customers, 94 orders
- **EIRE:** 265,545.90 revenue, 3 customers, 260 orders
- **Germany:** 228,867.14 revenue, 94 customers, 457 orders
- **France:** 209,024.05 revenue, 87 customers, 389 orders
- **Australia:** 138,521.31 revenue, 9 customers, 57 orders
- **Spain:** 61,577.11 revenue, 30 customers, 90 orders
- **Switzerland:** 56,443.95 revenue, 21 customers, 51 orders
- **Belgium:** 41,196.34 revenue, 25 customers, 98 orders
- **Sweden:** 38,378.33 revenue, 8 customers, 36 orders


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
