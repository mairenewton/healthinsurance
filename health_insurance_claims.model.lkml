connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: INT_MED_CLM_PRD {
  from: claim_detail
  view_label: "INT_MED_CLM_PRD"

  join: claims {
    view_label: "INT_MED_CLM_PRD"
    type: left_outer
    sql_on: ${INT_MED_CLM_PRD.claim_id} = ${claims.id} ;;
    relationship: many_to_one
  }

  join: members {
    view_label: "INT_MBR_MTH_PRD"
    type: left_outer
    sql_on: ${claims.member_id} = ${members.id} ;;
    relationship: many_to_one
  }

  join: svc_provider {
    view_label: "INT_MED_CLM_PRD"
    type: left_outer
    sql_on: ${claims.member_id} = ${svc_provider.svc_prov_id} ;;
    relationship: many_to_one
  }
}
