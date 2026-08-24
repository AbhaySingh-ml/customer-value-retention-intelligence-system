# Data Dictionary

## Project: Customer & Revenue Intelligence System

**Database:** PostgreSQL 18
**Schema:** public

---

## Table: `online_retail` (Raw)

Original table loaded from the UCI Online Retail dataset without analytical transformations.

| Column | Data Type | Description | Example |
|---|---|---|---|
| `invoice_no` | VARCHAR(20) | Invoice identifier. Prefix `C` indicates a cancellation/return | 536365, C536379 |
| `stock_code` | VARCHAR(20) | Product/item code | 85123A |
| `description` | VARCHAR(255) | Product name/description | WHITE HANGING HEART T-LIGHT HOLDER |
| `quantity` | INTEGER | Number of units in the transaction. Negative values represent returns | 6, -1 |
| `invoice_date` | TIMESTAMP | Date and time the transaction was generated | 2010-12-01 08:26:00 |
| `unit_price` | NUMERIC(10,2) | Price per unit in GBP (£) | 2.55 |
| `customer_id` | BIGINT | Unique customer identifier. NULL indicates an unregistered/guest transaction | 17850 |
| `country` | VARCHAR(50) | Country associated with the customer | United Kingdom |

**Raw row count:** 541,909

---

## Table: `online_retail_clean` (Cleaned)

Derived from `online_retail` after applying data-quality filters. This is the primary table used for analytical queries.

| Column | Data Type | Description | Example |
|---|---|---|---|
| `invoice_no` | VARCHAR(20) | Invoice identifier; cancellation invoices removed | 536365 |
| `stock_code` | VARCHAR(20) | Product/item code | 85123A |
| `description` | VARCHAR(255) | Product name/description | WHITE HANGING HEART T-LIGHT HOLDER |
| `quantity` | INTEGER | Positive units per transaction | 6 |
| `invoice_date` | TIMESTAMP | Date and time of transaction | 2010-12-01 08:26:00 |
| `unit_price` | NUMERIC(10,2) | Positive price per unit in GBP (£) | 2.55 |
| `customer_id` | BIGINT | Customer identifier; NULL values removed | 17850 |
| `country` | VARCHAR(50) | Country associated with the customer | United Kingdom |
| `revenue` | NUMERIC(10,2) | Derived revenue: `quantity * unit_price` | 15.30 |

**Cleaning rules applied:**

- Removed rows where `customer_id IS NULL`
- Removed rows where `quantity <= 0`
- Removed rows where `unit_price <= 0`
- Removed cancellation invoices where `invoice_no LIKE 'C%'`
- Added `revenue` as a derived column: `quantity * unit_price`

**Clean row count:** 397,880

---

## Derived Fields (Used in Analysis)

These fields are computed inside CTEs during analysis and are not stored as physical columns in the cleaned table.

| Field | Derived From | Logic | Used In |
|---|---|---|---|
| `recency_days` | `invoice_date` | Days between customer's last purchase and dataset reference date | RFM Analysis |
| `frequency` | `invoice_no` | `COUNT(DISTINCT invoice_no)` per customer | RFM Analysis |
| `monetary` | `revenue` | `SUM(revenue)` per customer | RFM Analysis |
| `r_score` | `recency_days` | `NTILE(5) OVER (ORDER BY recency_days ASC)` — score 1 = most recent | RFM Analysis |
| `f_score` | `frequency` | `NTILE(5) OVER (ORDER BY frequency DESC)` — score 1 = most frequent | RFM Analysis |
| `m_score` | `monetary` | `NTILE(5) OVER (ORDER BY monetary DESC)` — score 1 = highest spender | RFM Analysis |
| `customer_segment` | `r_score`, `f_score`, `m_score` | Multi-dimensional `CASE` logic | RFM Analysis |
| `growth_pct` | `monthly_revenue` | `(current - previous) / previous * 100` using `LAG()` | Revenue Analysis |

---

## RFM Score Reference

**Important:** In this project, lower scores represent better customers (score 1 = best, score 5 = worst).

This is because:

- Recency is ordered ascending: fewer days since purchase = better = score 1
- Frequency is ordered descending: more orders = better = score 1
- Monetary value is ordered descending: higher spend = better = score 1

| Score | Recency Meaning | Frequency Meaning | Monetary Meaning |
|---|---|---|---|
| 1 | Purchased most recently | Orders most frequently | Highest spender |
| 2 | Recent | Frequent | High spender |
| 3 | Moderate | Moderate | Moderate spender |
| 4 | Lapsing | Infrequent | Low spender |
| 5 | Longest ago | Rarely orders | Lowest spender |

---

## Customer Segments Reference

| Segment | Logic | Business Meaning |
|---|---|---|
| Champions | `r_score <= 2 AND f_score <= 2 AND m_score <= 2` | Recent, frequent, high-spend customers |
| Hibernating High Value | `r_score >= 4 AND f_score <= 2 AND m_score <= 2` | Historically frequent, high-spend customers who have gone inactive |
| Loyal | `f_score <= 2 AND m_score <= 3` | Frequent buyers with relatively strong spending |
| Promising | `r_score <= 2 AND f_score >= 4` | Recently active customers with low purchase frequency |
| At Risk | `r_score >= 4 AND f_score <= 3 AND m_score BETWEEN 3 AND 4` | Moderate-value customers showing signs of inactivity |
| Low Value | Everything else | Lower-engagement and lower-value customers |

---

## Data Quality Notes

| Issue | Resolution |
|---|---|
| NULL `customer_id` | Removed from the analytical table |
| Non-positive `quantity` | Removed from the analytical table |
| Non-positive `unit_price` | Removed from the analytical table |
| Cancellation invoices (`C%`) | Removed from the analytical table |
| Duplicate invoice lines | Retained; an invoice can contain multiple product lines |

The cleaned dataset was validated after processing:

- Clean rows: **397,880**
- NULL customer IDs: **0**
- Non-positive quantities: **0**
- Non-positive unit prices: **0**
- Cancellation invoices: **0**
- Non-positive revenue values: **0**

---

**Source:** UCI Machine Learning Repository — Online Retail Dataset

**Period:** 01 Dec 2010 – 09 Dec 2011

**Currency:** GBP (£)
