with source as (
    select * from {{ ref('raw_order_items') }}
),

cleaned as (
    select
        order_item_id,
        order_id,
        product_id,
        cast(quantity as integer) as quantity,
        cast(discount_pct as decimal(5, 4)) as discount_pct
    from source
)

select * from cleaned
