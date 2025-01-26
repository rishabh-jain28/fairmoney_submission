select 
    user_id,
    kyc_status,
    credit_score,
    verification_date
from {{ ref('stg_user_after_kyc') }} -- Referring to the stg_userafterkyc model
