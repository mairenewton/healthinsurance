view: claim_lines {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: claim_id {
    type: number
    #     hidden: true
    sql: ${TABLE}.order_id ;;
  }

  dimension: chrg_amt {
    type: number
    hidden: yes
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
  }
}
