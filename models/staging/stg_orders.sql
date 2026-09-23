with source as (
    select * from {{ ref('raw_orders') }}
),

cleaned as (
    select
        order_id,
        customer_id,
        cast(order_date as date) as order_date,
        lower(trim(order_status)) as order_status,
        lower(trim(shipping_mode)) as shipping_mode
    from source
)

select * from cleaned
