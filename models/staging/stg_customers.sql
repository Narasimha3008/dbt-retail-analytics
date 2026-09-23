with source as (
    select * from {{ ref('raw_customers') }}
),

cleaned as (
    select
        customer_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        lower(trim(email)) as email,
        trim(city) as city,
        trim(state) as state,
        trim(region) as region,
        cast(signup_date as date) as signup_date
    from source
)

select * from cleaned
