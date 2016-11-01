- view: members
  sql_table_name: demo_db.users
  fields:

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension: age
    type: number
    sql: ${TABLE}.age

  - dimension: city
    type: string
    sql: ${TABLE}.city

  - dimension: country
    type: string
    sql: ${TABLE}.country

  - dimension_group: member
    type: time
    timeframes: [month]
    sql: ${TABLE}.created_at

  - dimension: first_name
    type: string
    sql: ${TABLE}.first_name

  - dimension: gender
    type: string
    sql: ${TABLE}.gender

  - dimension: last_name
    type: string
    sql: ${TABLE}.last_name

  - dimension: state
    type: string
    map_layer: us_states
    sql: ${TABLE}.state

  - dimension: zip
    type: number
    map_layer: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip

  - measure: count
    type: count