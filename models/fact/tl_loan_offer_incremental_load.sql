--this script checks the existing records versues the new records from app api i.e spider DB
--updates the records of loan offers if they have any value changed or add new loan offers to the database

--source db1: SPIDER (DB)..loan_offer_spider
--source db2: FAIRMONEY (DB)..loan_offers_dim_rpt
--target db : mart/tl_loan_offer_change_tracker_view.sql

WITH source_data AS (
    -- Fetch all records from the source table (LOAN_OFFER_SPIDER)
    SELECT
        OFFER_ID,
        LOAN_AMOUNT,
        INTEREST_RATE,
        LOAN_TERM,
        MIN_CREDIT_SCORE,
        ELIGIBILITY_CRITERIA,
        OFFER_START_DATE,
        OFFER_END_DATE
    FROM {{ ref('loan_offer_spider') }}
),

current_dim AS (
    -- Fetch current records from the dimension table (loan_offers_dim_rpt)
    SELECT
        OFFER_ID,
        LOAN_AMOUNT,
        INTEREST_RATE,
        LOAN_TERM,
        MIN_CREDIT_SCORE,
        ELIGIBILITY_CRITERIA,
        OFFER_START_DATE,
        OFFER_END_DATE,
        CURRENT_ROW,
        LOSS_FLAG
    FROM {{ ref('loan_offers_dim_rpt') }}
    WHERE CURRENT_ROW = 1 -- Only consider active rows
),

changes AS (
    -- Identify new or updated records
    SELECT
        s.*,
        CASE
            WHEN c.OFFER_ID IS NULL THEN 'INSERT' -- New record
            WHEN (
                s.LOAN_AMOUNT <> c.LOAN_AMOUNT OR
                s.INTEREST_RATE <> c.INTEREST_RATE OR
                s.LOAN_TERM <> c.LOAN_TERM OR
                s.MIN_CREDIT_SCORE <> c.MIN_CREDIT_SCORE OR
                s.ELIGIBILITY_CRITERIA <> c.ELIGIBILITY_CRITERIA OR
                s.OFFER_START_DATE <> c.OFFER_START_DATE OR
                s.OFFER_END_DATE <> c.OFFER_END_DATE
            ) THEN 'UPDATE' -- Changed record
            ELSE 'NO_CHANGE'
        END AS CHANGE_TYPE
    FROM source_data s
    LEFT JOIN current_dim c
        ON s.OFFER_ID = c.OFFER_ID
),

updates AS (
    -- Prepare updates for existing records
    SELECT
        c.OFFER_ID,
        c.LOAN_AMOUNT,
        c.INTEREST_RATE,
        c.LOAN_TERM,
        c.MIN_CREDIT_SCORE,
        c.ELIGIBILITY_CRITERIA,
        c.OFFER_START_DATE,
        c.OFFER_END_DATE,
        0 AS CURRENT_ROW, -- Mark as outdated
        1 AS LOSS_FLAG -- Mark as historical
    FROM changes ch
    JOIN current_dim c
        ON ch.OFFER_ID = c.OFFER_ID
    WHERE ch.CHANGE_TYPE = 'UPDATE'
),

inserts AS (
    -- Prepare new records (new + updated)
    SELECT
        s.OFFER_ID,
        s.LOAN_AMOUNT,
        s.INTEREST_RATE,
        s.LOAN_TERM,
        s.MIN_CREDIT_SCORE,
        s.ELIGIBILITY_CRITERIA,
        s.OFFER_START_DATE,
        s.OFFER_END_DATE,
        1 AS CURRENT_ROW, -- Mark as active
        0 AS LOSS_FLAG -- Mark as active
    FROM changes s
    WHERE s.CHANGE_TYPE IN ('INSERT', 'UPDATE')
),

final_records AS (
    -- Combine updates and inserts
    SELECT * FROM updates
    UNION ALL
    SELECT * FROM inserts
)

SELECT * FROM final_records
