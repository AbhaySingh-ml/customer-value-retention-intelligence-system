# Customer & Revenue Intelligence System (SQL) 1 2 3 4 5 6 7

A end-to-end SQL analytics project built on a real-world e-commerce dataset (~500K rows).  
The goal is not just writing queries — but answering: **"How does this business make money, and what decisions should it take?"**

---

## Dataset

**Source:** [UCI Online Retail Dataset](https://archive.ics.uci.edu/ml/datasets/Online+Retail)  
**Period:** December 2010 – December 2011  
**Size:** ~541,909 rows (raw) → ~397,882 rows (after cleaning)  
**Description:** Transactional data from a UK-based online retailer selling gift items wholesale

| Column | Description |
|---|---|
| `InvoiceNo` | Unique invoice number (prefix 'C' = cancellation) |
| `StockCode` | Product code |
| `Description` | Product name |
| `Quantity` | Units per transaction |
| `InvoiceDate` | Date and time of transaction |
| `UnitPrice` | Price per unit in GBP |
| `CustomerID` | Unique customer identifier |
| `Country` | Customer's country |

---

## Project Structure

```
ecommerce-advanced-sql/
├── README.md
├── dataset/
│   ├── Online Retail.xlsx
│   ├── online_retail.csv
│   └── online_retail_utf8.csv
├── docs/
│   └── data_dictionary.md
├── results/
│   ├── monthly_revenue.csv
│   ├── product_analysis.csv
│   ├── rfm_score_diagnostic.csv
│   ├── rfm_customer_level.csv
│   ├── rfm_segment_summary.csv
│   ├── country_analysis.csv
│   └── top_countries_cumulative.csv
└── sql/
    ├── 01_create_table.sql
    ├── 02_data_cleaning.sql
    ├── 03_revenue_analysis.sql
    ├── 04_product_analysis.sql
    ├── 05_customer_intelligence.sql
    ├── 06_rfm_analysis.sql
    ├── 06b_rfm_diagnostic.sql
    └── 07_country_analysis.sql
```

---

## Modules

### Module 1 — Data Setup & Cleaning (`01`, `02`)
- Loaded raw dataset into PostgreSQL
- Removed NULL customers and returns (negative quantity)
- Created clean table: `online_retail_clean`
- Added derived column: `revenue = quantity * unit_price`

### Module 2 — Revenue Analysis (`03`)
- Monthly revenue aggregation
- Month-over-month growth % using `LAG()` window function
- Identified seasonal peaks and growth trends

### Module 3 — Product Analysis (`04`)
- Top products by revenue using `RANK()`
- Revenue contribution % per product
- Key finding: Long tail distribution — top 10% of products drive majority of revenue

### Module 4 — Customer Intelligence (`05`)
- Total spend, order frequency, average order value per customer
- Top 10% of customers → **61% of total revenue**
- Foundation for RFM segmentation

### Module 5 — RFM Segmentation (`06`, `06b`)
- Scored every customer on Recency, Frequency, Monetary using `NTILE(5)`
- Included diagnostic query (`06b`) to validate score boundaries before segmentation
- Final segments and results:

| Segment | Customers | Revenue | Avg Order Frequency | Avg Days Since Purchase |
|---|---|---|---|---|
| Champions | 961 | £5.76M (64.65%) | 11.0x | 12 days |
| Low Value | 2091 | £1.43M (16.04%) | 1.5x | 137 days |
| Loyal | 505 | £959K (10.77%) | 5.2x | 54 days |
| Hibernating High Value | 187 | £501K (5.62%) | 5.3x | 124 days |
| At Risk | 284 | £165K (1.86%) | 2.4x | 161 days |
| Promising | 310 | £94K (1.06%) | 1.3x | 17 days |

### Module 6 — Country Analysis (`07`)
- Revenue by country, customer count, avg order value
- Cumulative revenue concentration across markets

---

## Key Business Findings

**1. Revenue is dangerously concentrated**  
961 Champions (23% of customers) generate 64.65% of all revenue. Losing this segment would be catastrophic. Retention of Champions is the single highest-priority business action.

**2. The UK dependency is a strategic risk**  
82% of revenue comes from the UK alone. Any UK-specific disruption — economic, regulatory, or logistical — directly threatens business survival. International expansion is not optional, it's a risk management necessity.

**3. Hibernating High Value customers are a recoverable goldmine**  
187 customers with avg spend of £2,679 and 5.3 orders historically have gone quiet for 124 days. These are not lost customers — they are winnable. A targeted win-back campaign on this segment alone could recover £500K+ in revenue.

**4. Netherlands and Australia punch far above their weight**  
Netherlands: 9 customers, avg order value £121 (6x the UK average of £20).  
Australia: 9 customers, avg order value £117.  
These are small but premium markets that justify dedicated investment.

**5. Promising segment needs early nurturing**  
310 customers purchased within the last 17 days but avg spend is only £305. These are new or occasional buyers who haven't formed habits yet. Early engagement converts them into Loyal or Champions — ignoring them means losing them to churn.

**6. Long tail product distribution**  
Top 10% of products drive the majority of revenue. The bottom 50% of the catalogue contributes minimally and likely increases operational complexity without proportional return.

---

## SQL Techniques Used

| Technique | Where Used |
|---|---|
| `CTEs` (WITH clause) | All modules — query structuring |
| `Window Functions` — `LAG()` | Month-over-month revenue growth |
| `Window Functions` — `RANK()` | Top product ranking |
| `Window Functions` — `NTILE()` | RFM score bucketing |
| `Aggregate Functions` | Revenue, frequency, monetary metrics |
| `EXTRACT(EPOCH FROM interval)` | Converting interval to numeric days |
| `CASE WHEN` (multi-dimensional) | RFM segment classification |
| `Subqueries` | Revenue percentage calculations |
| `Date arithmetic` | Recency calculation |

---

## How to Run

**Requirements:** PostgreSQL 12+, pgAdmin or psql

```bash
# 1. Create the table
psql -d your_database -f sql/01_create_table.sql

# 2. Clean the data
psql -d your_database -f sql/02_data_cleaning.sql

# 3. Run modules in order
psql -d your_database -f sql/03_revenue_analysis.sql
psql -d your_database -f sql/04_product_analysis.sql
psql -d your_database -f sql/05_customer_intelligence.sql
psql -d your_database -f sql/06_rfm_analysis.sql
psql -d your_database -f sql/06b_rfm_diagnostic.sql
psql -d your_database -f sql/07_country_analysis.sql
```

---

## Why This Project

Built to demonstrate that SQL is not just a querying tool — it's a business intelligence tool.  
Every query in this project answers a real business question, not just a technical one.

---

*Database: PostgreSQL 18 | Tool: pgAdmin 4 | Dataset: UCI Machine Learning Repository*
