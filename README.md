# Customer Value & Retention Intelligence System

An end-to-end customer analytics project that transforms transactional e-commerce data into actionable customer value, retention, revenue, and geographic insights.

The project combines **PostgreSQL, SQL, Python, Pandas, SQLAlchemy, and RFM-style customer segmentation** to build a reproducible customer intelligence workflow.

---

## Business Objective

The objective is to answer practical business questions such as:

- Where is revenue being generated?
- Which customers contribute the most value?
- Which customers show signs of retention risk?
- How are customers distributed across behavioral segments?
- Which geographic markets contribute the most revenue?
- How can customer behavior support targeted retention and re-engagement strategies?

The project connects data preparation, analytical SQL, customer-level metrics, segmentation, visualization, and business interpretation into one workflow.

---

## Project Workflow

```text
Raw Transactional Data
        │
        ▼
    PostgreSQL
        │
        ├── Data Cleaning & Validation
        │
        ▼
Clean Transaction Table
        │
        ├── Revenue Analysis
        ├── Customer Analysis
        ├── Product Analysis
        ├── RFM Analysis
        └── Geographic Analysis
        │
        ▼
Python Analytical Layer
        │
        ├── Customer Metrics
        ├── RFM Segmentation
        ├── Revenue Analysis
        └── Country Analysis
        │
        ▼
Visualizations + CSV Outputs
        │
        ▼
Business Intelligence Report
```

---

## Dataset

**Source:** [UCI Online Retail Dataset](https://archive.ics.uci.edu/ml/datasets/online+retail)

| Attribute | Value |
|---|---|
| Period | December 2010 – December 2011 |
| Raw records | 541,909 |
| Cleaned transaction records | 397,880 |
| Unique customers | 4,338 |
| Countries analyzed | 37 |
| Months analyzed | 13 |

The dataset contains transactional information from a UK-based online retailer selling gift and household products.

### Main Fields

| Column | Description |
|---|---|
| `InvoiceNo` | Invoice or transaction identifier |
| `StockCode` | Product identifier |
| `Description` | Product description |
| `Quantity` | Number of units purchased |
| `InvoiceDate` | Transaction date and time |
| `UnitPrice` | Unit price |
| `CustomerID` | Customer identifier |
| `Country` | Customer's country |

> **Note:** The raw dataset is not included in this repository because of its size. The repository contains the SQL, Python pipeline, analytical outputs, documentation, and visualizations required to understand the analytical workflow.

---

## Analytical Modules

### 1. Data Setup & Cleaning

SQL is used to load and prepare the transactional data in PostgreSQL.

The cleaning workflow includes:

- Removing transactions without customer identifiers
- Removing return transactions based on negative quantities
- Creating the cleaned `online_retail_clean` table
- Calculating transaction-level revenue
- Validating row counts and data structure
- Investigating duplicate transactional records

The cleaned PostgreSQL table contains **397,880 transaction rows**, with analytical fields including:

```
invoice_no, stock_code, description, quantity,
invoice_date, unit_price, customer_id, country, revenue
```

---

### 2. Revenue Analysis

Monthly revenue is calculated from the cleaned transactional dataset.

**Verified Results**

| Metric | Value |
|---|---|
| Total revenue | 8,911,407.90 |
| Average monthly revenue | 685,492.92 |
| Months analyzed | 13 |

The analysis also examines month-level revenue movement and growth patterns using SQL window functions.

**Outputs**
- `results/monthly_revenue.csv`
- `results/charts/monthly_revenue_trend.png`

---

### 3. Customer Value Analysis

Customer-level behavioral metrics are calculated from transaction history.

**Metrics include:**
- Total orders
- Total revenue
- Average order value
- First purchase date
- Last purchase date
- Customer lifetime duration
- Active months
- Orders per active month
- Purchase frequency

The resulting analytical dataset contains **4,338 customer records**, providing a customer-level view of value and purchasing behavior instead of evaluating revenue only at the transaction level.

**Output**
- `results/rfm_customer_level.csv`

---

### 4. RFM-Style Customer Segmentation

Customers are segmented using **Recency, Frequency, and Monetary** behavioral dimensions.

The SQL implementation uses PostgreSQL window functions such as `NTILE(5)` to create behavioral score buckets.

The segmentation logic is validated through a dedicated diagnostic analysis before producing the final customer segments.

**Customer Segment Distribution**

| Segment | Customers | Share |
|---|---:|---:|
| Low Value | 2,091 | 48.20% |
| Champions | 961 | 22.15% |
| Loyal | 505 | 11.64% |
| Promising | 310 | 7.15% |
| At Risk | 284 | 6.55% |
| Hibernating High Value | 187 | 4.31% |

**Segment Interpretation**

| Segment | Interpretation |
|---|---|
| **Champions** | High-value customers with strong purchasing behavior. Important retention targets. |
| **Loyal** | Customers demonstrating relatively consistent purchasing behavior and meaningful historical value. |
| **Promising** | Customers with recent purchasing activity who may have potential to develop stronger purchasing habits. |
| **At Risk** | Customers whose purchasing behavior indicates weaker recent engagement and potential retention risk. |
| **Hibernating High Value** | Previously valuable customers showing significant inactivity. Represents a potential win-back opportunity. |
| **Low Value** | Customers with relatively limited purchasing activity or historical value. |

**Outputs**
- `results/rfm_customer_level.csv`
- `results/rfm_segment_summary.csv`
- `results/rfm_score_diagnostic.csv`
- `results/charts/rfm_customer_segments.png`
- `results/charts/rfm_segment_revenue.png`

---

### 5. Geographic Revenue Analysis

Revenue and customer activity are analyzed across countries.

**Top Revenue Markets**

| Country | Revenue | Customers | Orders |
|---|---:|---:|---:|
| United Kingdom | 7,308,391.55 | 3,920 | 16,646 |
| Netherlands | 285,446.34 | 9 | 94 |
| EIRE | 265,545.90 | 3 | 260 |
| Germany | 228,867.14 | 94 | 457 |
| France | 209,024.05 | 87 | 389 |
| Australia | 138,521.31 | 9 | 57 |
| Spain | 61,577.11 | 30 | 90 |
| Switzerland | 56,443.95 | 21 | 51 |
| Belgium | 41,196.34 | 25 | 98 |
| Sweden | 38,378.33 | 8 | 36 |

The analysis demonstrates a strong concentration of revenue in the United Kingdom while also highlighting smaller international markets.

**Outputs**
- `results/country_analysis.csv`
- `results/top_countries_cumulative.csv`
- `results/charts/top_countries_revenue.png`

---

## Key Business Findings

### 1. Revenue is highly concentrated in the United Kingdom

The United Kingdom generated approximately **7.31M** in recorded revenue, making it the dominant geographic market in the dataset.

**Business implication:** The existing UK customer base represents a major revenue dependency. Retention and service quality in this market are strategically important, while international markets provide potential diversification opportunities.

### 2. Low Value customers form the largest customer segment

The Low Value segment contains **2,091 customers (48.20%)** of analyzed customers.

**Business implication:** A large portion of the customer base has relatively limited purchasing activity. Targeted re-engagement, product recommendations, and conversion strategies could be used to investigate whether some of these customers can become repeat purchasers.

### 3. Champions represent a significant high-value segment

The Champions segment contains **961 customers (22.15%)** of analyzed customers, and contributes the largest share of revenue among the RFM-style customer segments.

**Business implication:** Champions should receive priority in retention strategies because losing highly engaged customers can have a disproportionate effect on revenue.

### 4. At Risk and Hibernating High Value customers are retention opportunities

The analysis identifies **284 At Risk** and **187 Hibernating High Value** customers, both showing weaker recent purchasing activity compared with stronger-performing segments.

**Business implication:** These groups are suitable targets for win-back and re-engagement campaigns, particularly the Hibernating High Value segment because of its historical customer value.

### 5. Geographic performance is uneven

Revenue contribution varies significantly between countries. The United Kingdom accounts for the majority of recorded revenue, while countries such as Germany, France, the Netherlands, EIRE, and Australia contribute smaller but potentially meaningful amounts.

**Business implication:** Customer retention and market expansion strategies should consider geographic differences instead of treating all markets uniformly.

---

## SQL Techniques Demonstrated

| Technique | Application |
|---|---|
| CTEs | Structuring multi-stage analytical queries |
| Aggregate Functions | Revenue, customer, product, and country metrics |
| `LAG()` | Month-over-month revenue analysis |
| `RANK()` | Product ranking |
| `NTILE()` | RFM score bucketing |
| `CASE WHEN` | Customer segment classification |
| Window Functions | Ranking and behavioral analysis |
| Date Arithmetic | Recency and customer lifetime calculations |
| Subqueries | Revenue contribution calculations |
| `GROUP BY` | Customer, product, country, and time aggregation |
| Duplicate Analysis | Transaction-level data validation |

---

## Python Analytical Layer

The Python layer converts the SQL-backed data into reusable analytical functions.

**Main Components**

```
Python/
├── analysis/
│   ├── country_analysis.py
│   ├── customer_analysis.py
│   ├── revenue_analysis.py
│   ├── rfm_analysis.py
│   └── run_analysis.py
│
├── db/
│   ├── __init__.py
│   └── connection.py
│
├── reports/
│   ├── __init__.py
│   └── generate_report.py
│
├── visualization/
│   └── charts.py
│
├── requirements.txt
└── README.md
```

The database connection layer uses environment variables rather than hard-coded credentials.

**Example configuration**

```env
DB_HOST=
DB_PORT=
DB_NAME=
DB_USER=
DB_PASSWORD=
```

> The actual `.env` file is intentionally excluded from version control.

---

## Visualizations

The project generates four primary visualizations:

| Visualization | Description |
|---|---|
| Monthly Revenue Trend | Shows revenue movement across the 13-month analytical period |
| Customer Distribution by RFM Segment | Shows the size of each customer behavioral segment |
| Revenue by RFM Segment | Shows how revenue is distributed across customer segments |
| Top Countries by Revenue | Shows the geographic concentration of recorded revenue |

Generated charts are available under `results/charts/`.

---

## Generated Analytical Outputs

The project produces reusable CSV outputs including:

```
results/
├── monthly_revenue.csv
├── product_analysis.csv
├── rfm_customer_level.csv
├── rfm_score_diagnostic.csv
├── rfm_segment_summary.csv
├── country_analysis.csv
└── top_countries_cumulative.csv
```

These outputs can be consumed by downstream reporting, dashboards, or further machine learning workflows.

---

## Project Structure

```
customer-value-retention-intelligence-system/
│
├── README.md
│
├── Python/
│   ├── analysis/
│   ├── db/
│   ├── reports/
│   ├── visualization/
│   ├── README.md
│   └── requirements.txt
│
├── docs/
│   ├── data_dictionary.md
│   └── customer_value_retention_report.md
│
├── results/
│   ├── *.csv
│   └── charts/
│
├── sql/
│   ├── 01_create_table.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_revenue_analysis.sql
│   ├── 04_product_analysis.sql
│   ├── 05_customer_intelligence.sql
│   ├── 06_rfm_analysis.sql
│   ├── 06b_rfm_diagnostic.sql
│   ├── 07_country_analysis.sql
│   └── 08_rfm_segment_summary.sql
│
├── .env.example
├── .gitignore
└── README.md
```

---

## How to Run

### Requirements

- PostgreSQL
- Python 3.10+
- pip
- `psql` or pgAdmin
- Git

### 1. Clone the repository

```bash
git clone <repository-url>
cd customer-value-retention-intelligence-system
```

### 2. Create and activate a virtual environment

```bash
python -m venv .venv
source .venv/bin/activate
```

On Windows:

```bash
.venv\Scripts\activate
```

### 3. Install Python dependencies

```bash
pip install -r Python/requirements.txt
```

### 4. Configure PostgreSQL

Create a PostgreSQL database and configure the environment variables using `.env.example`.

Create your local `.env` file:

```env
DB_HOST=your_host
DB_PORT=5432
DB_NAME=your_database
DB_USER=your_user
DB_PASSWORD=your_password
```

> The `.env` file is ignored by Git and should never be committed.

### 5. Load and clean the data

The SQL workflow is organized sequentially:

```bash
psql -d your_database -f sql/01_create_table.sql
psql -d your_database -f sql/02_data_cleaning.sql
```

Then run the analytical SQL modules:

```bash
psql -d your_database -f sql/03_revenue_analysis.sql
psql -d your_database -f sql/04_product_analysis.sql
psql -d your_database -f sql/05_customer_intelligence.sql
psql -d your_database -f sql/06_rfm_analysis.sql
psql -d your_database -f sql/06b_rfm_diagnostic.sql
psql -d your_database -f sql/07_rfm_segment_summary.sql
psql -d your_database -f sql/08_country_analysis.sql
```

### 6. Run the Python analysis

From the project root:

```bash
python Python/analysis/run_analysis.py
```

The Python layer connects to PostgreSQL and generates the analytical outputs.

### 7. Generate visualizations

```bash
python Python/visualization/charts.py
```

Charts are written to `results/charts/`.

### 8. Generate the business report

```bash
python Python/reports/generate_report.py
```

The generated report is written to `docs/customer_value_retention_report.md`.

---

## Technical Stack

| Category | Tools |
|---|---|
| Database | PostgreSQL, SQL, pgAdmin / psql |
| Python | Python, Pandas, SQLAlchemy, psycopg2, python-dotenv |
| Visualization | Matplotlib, Seaborn |
| Development | Git, GitHub, VS Code |

---

## Project Outcome

This project demonstrates an end-to-end analytical workflow rather than isolated SQL queries or Python scripts.

The final pipeline connects:

```
Data Cleaning
      ↓
SQL Validation
      ↓
Revenue Analysis
      ↓
Customer-Level Metrics
      ↓
RFM-Style Segmentation
      ↓
Geographic Analysis
      ↓
Python Analytics
      ↓
Visualizations
      ↓
Business Recommendations
```

The resulting system can support:

- Customer segmentation
- Revenue monitoring
- Retention analysis
- Customer value analysis
- Geographic market analysis
- Re-engagement strategy
- Future predictive modeling

---

## Future Extensions

The current project establishes the analytical foundation for more advanced customer intelligence systems.

Potential extensions include:

- Customer churn prediction
- Customer lifetime value (CLV) modeling
- Revenue forecasting
- Product recommendation systems
- Customer-level propensity modeling
- Automated dashboarding
- Scheduled analytical pipelines
- ML-based retention prediction

---

## Author

**Abhay Singh**
MCA — AI/ML

Interested in building data-driven systems at the intersection of AI, machine learning, finance, and business analytics.
