SELECT *
FROM {{ source('fairmoney', 'LOAN_OFFERS_DIM') }}