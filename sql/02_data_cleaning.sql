-- =========================================================
-- DATA CLEANING STEP
-- =========================================================
-- Objective:
-- Create a cleaned version of the dataset by removing
-- invalid, incomplete, and non-revenue-generating records.
--
-- Why cleaning is required:
-- Raw transactional data contains:
-- - Missing customer IDs
-- - Product returns (negative quantity)
-- - Invalid prices
-- - Cancelled invoices
--
-- These distort revenue, customer segmentation, and analytics.
-- =========================================================


-- =========================================================
-- STEP 1: CREATE CLEAN TABLE
-- =========================================================
-- We create a new table instead of modifying raw data
-- to preserve original dataset (best practice in analytics)

CREATE TABLE online_retail_clean AS
SELECT *
FROM online_retail
WHERE 
    -- Remove rows with missing customer ID
    -- Required for customer-level analysis (RFM, segmentation)
    customer_id IS NOT NULL

    AND

    -- Remove returns (negative or zero quantity)
    -- Returns are not actual purchases
    quantity > 0

    AND

    -- Remove invalid or free products
    -- Revenue calculation requires positive price
    unit_price > 0

    AND

    -- Remove cancelled invoices
    -- Invoice numbers starting with 'C' indicate cancellations
    invoice_no NOT LIKE 'C%';


-- =========================================================
-- STEP 2: VALIDATE CLEANING
-- =========================================================
-- Ensure all invalid records are removed

-- Check for NULL customer IDs
SELECT COUNT(*) AS null_customers
FROM online_retail_clean
WHERE customer_id IS NULL;

-- Check for negative or zero quantity
SELECT COUNT(*) AS invalid_quantity
FROM online_retail_clean
WHERE quantity <= 0;

-- Check for invalid prices
SELECT COUNT(*) AS invalid_price
FROM online_retail_clean
WHERE unit_price <= 0;


-- =========================================================
-- STEP 3: ADD REVENUE COLUMN
-- =========================================================
-- Revenue = Quantity × Unit Price
-- Precomputing this improves performance in future queries

ALTER TABLE online_retail_clean
ADD COLUMN revenue NUMERIC(12,2);


-- Populate revenue values
UPDATE online_retail_clean
SET revenue = quantity * unit_price;


-- =========================================================
-- STEP 4: FINAL CHECK
-- =========================================================
-- Confirm cleaned dataset size

SELECT COUNT(*) AS cleaned_row_count
FROM online_retail_clean;