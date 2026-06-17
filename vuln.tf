resource "github_repository_vulnerability_alerts" "this" {
  for_each   = { for k, v in github_repository.this : k => v.name }
  repository = each.value
  # Public repos get vulnerability alerts free on all plans.
  # Private repos require GitHub Advanced Security (Enterprise / Team add-on).
}
