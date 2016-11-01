- view: claim_detail
  derived_table:
    sql: |
      SELECT
         id AS id
        ,1*ROUND((RAND() * (297-102))+102) AS proc_cd1
        ,1*ROUND((RAND() * (598-341))+341) AS proc_cd2
        ,1*ROUND((RAND() * (837-604))+604) AS proc_cd3
        ,1*ROUND((RAND() * (444-111))+111) AS icd9_cd1
        ,1*ROUND((RAND() * (555-333))+333) AS icd9_cd2
        ,1*ROUND((RAND() * (888-222))+222) AS icd9_cd3
        ,order_id AS claim_id
        ,ROUND((RAND() * (59-34))+34)/100 AS disct_pct
        ,CASE WHEN sale_price < 30
          THEN 30*(ROUND((RAND() * (80-50))+50))
          ELSE sale_price*(ROUND((RAND() * (80-50))+50))
          END AS chrg_amt
        ,ROUND((RAND() * (100-0))+0) AS copay_amt
        ,ROUND((RAND() * (250-0))+0) AS deduct_amt
        ,ROUND((RAND() * (20-0))+0)/100 AS coins_pct
      FROM order_items
    indexes: [id]
    persist_for: 10 hours

  fields:
  - dimension: id
    type: number
    primary_key: true
    hidden: true
    sql: ${TABLE}.id

  - dimension: proc_cd1
    type: number
    sql: ${TABLE}.proc_cd1
    value_format_name: decimal_0

  - dimension: proc_cd2
    type: number
    sql: ${TABLE}.proc_cd2
    value_format_name: decimal_0

  - dimension: proc_cd3
    type: number
    sql: ${TABLE}.proc_cd3
    value_format_name: decimal_0

  - dimension: icd9_cd1
    type: number
    sql: ${TABLE}.icd9_cd1
    value_format_name: decimal_0

  - dimension: icd9_cd2
    type: number
    sql: ${TABLE}.icd9_cd2
    value_format_name: decimal_0

  - dimension: icd9_cd3
    type: number
    sql: ${TABLE}.icd9_cd3
    value_format_name: decimal_0

  - dimension: claim_id
    type: number
    sql: ${TABLE}.claim_id
    
  - dimension: msc_nm
    type: string
    sql_case:
      "Inpatient Facility": ${proc_cd1} < 140
      "Outpatient Facility": ${proc_cd1} >= 140 AND ${proc_cd1} < 190
      "Professional Services": ${proc_cd1} >= 190 AND ${proc_cd1} < 240
      "Other Medical Services": ${proc_cd1} >= 240 AND ${proc_cd1} < 260
      "Pharmacy": ${proc_cd1} > 260

  - dimension: disct_pct
    type: number
    hidden: true
    value_format_name: percent_2
    sql: ${TABLE}.disct_pct

  - dimension: chrg_amt
    type: number
    hidden: true
    sql: |
      CASE
        WHEN ${msc_nm} = "Pharmacy" THEN ${TABLE}.chrg_amt/4
        WHEN ${msc_nm} = "Inpatient Facility" THEN ${TABLE}.chrg_amt*3
        WHEN ${msc_nm} = "Outpatient Facility" THEN ${TABLE}.chrg_amt*1.5
        ELSE ${TABLE}.chrg_amt
      END

  - dimension: copay_amt
    type: number
    hidden: true
    value_format_name: usd
    sql: ${TABLE}.copay_amt
    
  - dimension: deductible_amt
    type: number
    hidden: true
    value_format_name: usd
    sql: ${TABLE}.deduct_amt

  - dimension: coins_pct
    type: number
    hidden: true
    value_format_name: percent_2
    sql: ${TABLE}.coins_pct
    
  - dimension: coins_amt
    type: number
    hidden: true
    value_format_name: usd
    sql: ${chrg_amt}*${coins_pct}
    
  - dimension: disct_amt
    type: number
    hidden: true
    value_format_name: usd
    sql: ${chrg_amt}*${disct_pct}
    
  - measure: derv_chrg_amt
    type: sum
    value_format_name: usd
    sql: ${chrg_amt}
    
  - measure: derv_copay_amt
    type: sum
    value_format_name: usd
    sql: ${copay_amt}
    
  - measure: derv_coins_amt
    type: sum
    value_format_name: usd
    sql: ${coins_amt}
  
  - measure: derv_deductible_amt
    type: sum
    value_format_name: usd
    sql: ${deductible_amt}
    
  - measure: derv_cost_share_amt
    type: number
    value_format_name: usd
    sql: ${derv_copay_amt} + ${derv_coins_amt} + ${derv_deductible_amt}
    
  - measure: derv_disct_amt
    type: sum
    value_format_name: usd
    sql: ${disct_amt}
    
  - measure: derv_paybl_amt
    type: number
    value_format_name: usd
    sql: ${derv_chrg_amt} - ${derv_disct_amt} - ${derv_cost_share_amt}
    
  - measure: derv_avg_paid_per_claim
    type: number
    value_format_name: usd
    sql: ${derv_paybl_amt}/${count}
    
  - measure: derv_avg_paid_per_claim_scatter
    type: number
    value_format_name: usd
    sql: ${derv_paybl_amt}/${count}
    html: |
       <div>MSC: {{ msc_nm._rendered_value }} </div>
       <div>Procedure Code: {{ proc_cd1._rendered_value }}</div>
       <div>Average Paid per Claim: {{ rendered_value }}</div>
       <div>Claim Count: {{ count._value}}</div>
    
  - measure: count
    type: count
    html: |
      <div> </div>