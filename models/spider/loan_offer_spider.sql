SELECT *
FROM {{ source('fairmoney', 'LOAN_OFFER_SPIDER') }}