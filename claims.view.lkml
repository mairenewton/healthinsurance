view: claims {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: svc {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      month_num,
      month_name,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: pd {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      month_num,
      month_name,
      year
    ]
    sql: DATE_ADD(${TABLE}.created_at, INTERVAL 60 DAY) ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: member_id {
    type: number
    # hidden: true
    sql: ${TABLE}.user_id ;;
  }
}
