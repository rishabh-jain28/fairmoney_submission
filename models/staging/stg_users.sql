WITH raw_users AS (
    SELECT * 
    FROM {{ ref('fm_user_dim') }}  -- Referring to the users source model
)

SELECT 
    user_id,
    first_name,
    last_name,
    LOWER(email) AS email,  -- Standardizing email to lowercase
    created_at,
    updated_at,
    date_of_birth,  -- Calculating age from date_of_birth
    password_hash
FROM raw_users