with repayments as (
    select 
        user_id,
        offer_id,
        repayment_status,
        repayment_date,
        amount_paid
    from {{ ref('user_dim_rpt') }} u
    join {{ ref('loan_offers_dim_rpt') }} l
        on u.user_id = l.user_id  
)

select 
    user_id,
    offer_id,
    repayment_status,
    repayment_date,
    amount_paid
from repayments
