with raw_userafterkyc as (
    select * from {{ ref('fm_user_kyc_dim') }}  -- Referring to the userafterkyc source model
)

select 
    user_id,
    kyc_status,
    credit_score,
    verification_date
from raw_userafterkyc
