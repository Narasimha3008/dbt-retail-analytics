{{ config(materialized='table') }}
-- Monthly business KPIs, the table a BI tool would point at.

with fct as (
    select * from {{ ref('fct_orders') }}
),

monthly as (
    select
        date_trunc('month', order_date) as month,
        count(distinct order_id) as total_orders,
        count(distinct case when order_status = 'completed' then order_id end) as completed_orders,
        count(distinct customer_id) as active_customers,
        sum(gross_revenue) as revenue,
        sum(gross_profit) as profit
    from fct
    group by 1
)

select
    month,
    total_orders,
    completed_orders,
    active_customers,
    revenue,
    profit,
    round(revenue / nullif(completed_orders, 0), 2) as avg_order_value,
    round(profit / nullif(revenue, 0), 4) as profit_margin_pct
from monthly
