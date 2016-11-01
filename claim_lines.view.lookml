- view: claim_lines
  sql_table_name: demo_db.order_items
  fields:

  - dimension: id
    primary_key: true
    hidden: true
    type: number
    sql: ${TABLE}.id

  - dimension: claim_id
    type: number
#     hidden: true
    sql: ${TABLE}.order_id

  - dimension: chrg_amt
    type: number
    hidden: true
    sql: ${TABLE}.sale_price

  - measure: count
    type: count