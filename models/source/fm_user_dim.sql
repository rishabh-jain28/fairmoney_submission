SELECT *
FROM {{ source('fairmoney', 'FAIR_MONEY_USERS_DIM') }}