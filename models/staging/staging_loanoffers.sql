with raw_loanoffers as (
    select * from {{ ref('fm_loan_offers') }}  -- Referring to the loanoffers source model
)

select 
    offer_id,
    loan_amount,
    interest_rate,
    loan_term,
    min_credit_score,
    eligibility_criteria,
    offer_start_date,
    offer_end_date
from raw_loanoffers
