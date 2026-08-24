-- =========================================================
-- MODULE 2: DATA CLEANING
-- =========================================================
-- Objective:
-- Create a cleaned analytical table while preserving the
-- original raw dataset.
--
-- Cleaning rules:
-- 1. Remove rows with NULL customer_id
-- 2. Remove rows with quantity <= 0
-- 3. Remove rows with unit_price <= 0
-- 4. Remove cancellation invoices beginning with 'C'
-- 5. Add revenue = quantity * unit_price
-- =========================================================


-- =========================================================
-- STEP 1: RECREATE CLEAN TABLE
-- =========================================================

-- Keep the raw table unchanged.
-- Recreating the table makes this script reproducible.

DROP TABLE IF EXISTS online_retail_clean;

CREATE TABLE online_retail_clean AS
SELECT
    *
FROM online_retail
WHERE
    customer_id IS NOT NULL
    AND quantity > 0
    AND unit_price > 0
    AND invoice_no NOT LIKE 'C%';


-- =========================================================
-- STEP 2: ADD DERIVED REVENUE
-- =========================================================

-- Revenue = Quantity × Unit Price

ALTER TABLE online_retail_clean
ADD COLUMN revenue NUMERIC(12,2);

UPDATE online_retail_clean
SET revenue = quantity * unit_price;


-- =========================================================
-- STEP 3: DATA QUALITY VALIDATION
-- =========================================================

SELECT
    COUNT(*) AS clean_rows,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS null_customers,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS invalid_quantity,

    COUNT(*) FILTER (
        WHERE unit_price <= 0
    ) AS invalid_price,

    COUNT(*) FILTER (
        WHERE invoice_no LIKE 'C%'
    ) AS cancellations,

    COUNT(*) FILTER (
        WHERE revenue <= 0
    ) AS invalid_revenue

FROM online_retail_clean;


-- =========================================================
-- STEP 4: FINAL ROW COUNT
-- =========================================================

SELECT
    COUNT(*) AS clean_row_count
FROM online_retail_clean;