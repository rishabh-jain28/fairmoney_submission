with loan_defaults as (
    select 
        user_id,
        offer_id,
        default_status,
        default_date,
        amount_due
    from {{ ref('user_dim_rpt') }} u
    join {{ ref('loan_offers_dim_rpt') }} l
        on u.user_id = l.user_id  -- Joining user and loan data for defaults
)

select 
    user_id,
    offer_id,
    default_status,
    default_date,
    amount_due
from loan_defaults
