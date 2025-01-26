with loan_data as (
    select 
        user_id,
        offer_id,
        loan_amount,
        loan_term,
        interest_rate
    from {{ ref('user_dim_rpt') }} u
    join {{ ref('loan_offers_dim_rpt') }} l
        on u.user_id = l.user_id  -- Linking user data with loan offers
)

select 
    user_id,
    offer_id,
    loan_amount,
    loan_term,
    interest_rate
from loan_data
