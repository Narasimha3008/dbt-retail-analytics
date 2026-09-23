{{ config(materialized='table') }}
-- One row per order line item, with revenue / cost / profit.
-- Only 'completed' orders contribute revenue; cancelled/returned lines are
-- kept for funnel analysis with zeroed financials.

with order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

joined as (
    select
        oi.order_item_id,
        oi.order_id,
        o.customer_id,
        oi.product_id,
        o.order_date,
        o.order_status,
        o.shipping_mode,
        p.category,
        p.subcategory,
        oi.quantity,
        p.unit_price,
        p.unit_cost,
        oi.discount_pct,
        case
            when o.order_status = 'completed'
                then round(oi.quantity * p.unit_price * (1 - oi.discount_pct), 2)
            else 0
        end as gross_revenue,
        case
            when o.order_status = 'completed'
                then round(oi.quantity * p.unit_cost, 2)
            else 0
        end as total_cost
    from order_items oi
    inner join orders o on oi.order_id = o.order_id
    inner join products p on oi.product_id = p.product_id
)

select
    *,
    round(gross_revenue - total_cost, 2) as gross_profit
from joined
