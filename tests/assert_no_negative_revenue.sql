-- Singular test: revenue must never be negative.
-- Fails (returns rows) if any fact row has gross_revenue < 0.

select
    order_item_id,
    order_id,
    gross_revenue
from {{ ref('fct_orders') }}
where gross_revenue < 0
