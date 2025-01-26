select 
    l.offer_id,
    l.loan_amount,
    r.repayment_status,
    r.repayment_date,
    d.default_status
from {{ ref('loans_repayment_rpt_fact') }} r
join {{ ref('loan_default_rpt_fact') }} d
    on r.offer_id = d.offer_id
join {{ ref('loan_offers_dim_rpt') }} l
    on l.offer_id = r.offer_id
