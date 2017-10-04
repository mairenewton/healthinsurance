view: svc_provider {
  sql_table_name: demo_db.users ;;

  dimension: svc_prov_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: svc_prov_city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: svc_prov_country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: svc_prov_first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: svc_prov_last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: svc_prov_state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: svc_prov_zip {
    type: number
    sql: ${TABLE}.zip ;;
  }
}
