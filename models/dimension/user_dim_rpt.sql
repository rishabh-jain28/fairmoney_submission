select 
    user_id,
    first_name,
    last_name,
    email,
    created_at,
    updated_at,
    date_of_birth
from {{ ref('stg_users') }} -- Referring to the stg_users model
