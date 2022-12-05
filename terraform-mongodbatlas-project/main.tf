locals {
  project = {for k, v in var.projects : v.name => v }
}

resource "mongodbatlas_project" "project" {
  for_each = local.project
  org_id   = var.organization_id
  name     = each.key

  dynamic teams {
    for_each = var.teams
    content {
      team_id    = teams.value.team_id
      role_names = teams.value.role_names
    }
  }

  is_collect_database_specifics_statistics_enabled = true
  is_data_explorer_enabled                         = true
  is_performance_advisor_enabled                   = true
  is_realtime_performance_panel_enabled            = true
  is_schema_advisor_enabled                        = true
}