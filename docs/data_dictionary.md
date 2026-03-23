# Data Dictionary

## Project: Customer & Revenue Intelligence System
**Database:** PostgreSQL 18  
**Schema:** public  

---

## Table: `online_retail` (Raw)

Original table loaded directly from the UCI Online Retail dataset without any modifications.

| Column | Data Type | Description | Example |
|---|---|---|---|
| `invoice_no` | VARCHAR(20) | Unique invoice identifier. Prefix 'C' indicates a cancellation/return | 536365, C536379 |
| `stock_code` | VARCHAR(20) | Unique product/item code | 85123A |
| `description` | VARCHAR(255) | Product name/description | WHITE HANGING HEART T-LIGHT HOLDER |
| `quantity` | INTEGER | Number of units per transaction. Negative = return | 6, -1 |
| `invoice_date` | TIMESTAMP | Date and time the transaction was generated | 2010-12-01 08:26:00 |
| `unit_price` | NUMERIC(10,2) | Price per unit in GBP (£) | 2.55 |
| `customer_id` | VARCHAR(20) | Unique identifier for each customer. NULL = guest/unregistered | 17850 |
| `country` | VARCHAR(50) | Country where the customer resides | United Kingdom |

**Raw row count:** ~541,909  

---

## Table: `online_retail_clean` (Cleaned)

Derived from `online_retail` after applying data quality filters. This is the primary table used in all analysis modules.

| Column | Data Type | Description | Example |
|---|---|---|---|
| `invoice_no` | VARCHAR(20) | Unique invoice identifier (cancellations removed) | 536365 |
| `stock_code` | VARCHAR(20) | Unique product/item code | 85123A |
| `description` | VARCHAR(255) | Product name/description | WHITE HANGING HEART T-LIGHT HOLDER |
| `quantity` | INTEGER | Units per transaction (negatives removed) | 6 |
| `invoice_date` | TIMESTAMP | Date and time of transaction | 2010-12-01 08:26:00 |
| `unit_price` | NUMERIC(10,2) | Price per unit in GBP (£) | 2.55 |
| `customer_id` | VARCHAR(20) | Unique customer identifier (NULLs removed) | 17850 |
| `country` | VARCHAR(50) | Country where the customer resides | United Kingdom |
| `revenue` | NUMERIC(10,2) | Derived column: `quantity * unit_price` | 15.30 |

**Cleaning rules applied:**
- Removed rows where `customer_id IS NULL`
- Removed rows where `quantity < 0` (returns and cancellations)
- Added `revenue` as a derived column

**Clean row count:** ~397,882  

---

## Derived Fields (Used in Analysis)

These fields are not stored as columns — they are computed inside CTEs during analysis.

| Field | Derived From | Logic | Used In |
|---|---|---|---|
| `recency_days` | `invoice_date` | Days between customer's last purchase and dataset max date | RFM Analysis |
| `frequency` | `invoice_no` | `COUNT(DISTINCT invoice_no)` per customer | RFM Analysis |
| `monetary` | `revenue` | `SUM(revenue)` per customer | RFM Analysis |
| `r_score` | `recency_days` | `NTILE(5) ORDER BY recency_days ASC` — score 1 = most recent | RFM Analysis |
| `f_score` | `frequency` | `NTILE(5) ORDER BY frequency DESC` — score 1 = most frequent | RFM Analysis |
| `m_score` | `monetary` | `NTILE(5) ORDER BY monetary DESC` — score 1 = highest spend | RFM Analysis |
| `customer_segment` | `r_score, f_score, m_score` | Multi-dimensional CASE logic | RFM Analysis |
| `growth_pct` | `monthly_revenue` | `(current - previous) / previous * 100` using LAG() | Revenue Analysis |

---

## RFM Score Reference

**Important:** In this project, lower scores = better customers (score 1 = best, score 5 = worst).  
This is because NTILE orders recency ASC (fewer days = better = score 1) and frequency/monetary DESC (higher = better = score 1).

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
| Champions | `r<=2 AND f<=2 AND m<=2` | Recent, frequent, high spend — best customers |
| Hibernating High Value | `r>=4 AND f<=2 AND m<=2` | High spend + frequent historically, but gone quiet |
| Loyal | `f<=2 AND m<=3` | Frequent buyers with decent spend |
| Promising | `r<=2 AND f>=4` | Recently active but low frequency — new or occasional |
| At Risk | `r>=4 AND f<=3 AND m BETWEEN 3 AND 4` | Moderate customers going quiet |
| Low Value | Everything else | Low engagement, low spend |

---

## Data Quality Notes

| Issue | Volume | Resolution |
|---|---|---|
| NULL customer_id | ~135,080 rows | Removed — cannot attribute to a customer |
| Negative quantity (returns) | ~10,624 rows | Removed — distorts revenue figures |
| Zero unit_price | Small number | Retained — may be samples or internal transfers |
| Duplicate invoice lines | Normal | Expected — one invoice can have multiple products |

---

*Source: UCI Machine Learning Repository — Online Retail Dataset*  
*Period: 01 Dec 2010 – 09 Dec 2011*  
*Currency: GBP (£)*