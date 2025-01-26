SELECT *
FROM {{ source('fairmoney', 'COLLECTION_EXECUTIVES_DIM') }}