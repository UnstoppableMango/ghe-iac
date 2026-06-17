resource "github_repository_vulnerability_alerts" "this" {
  for_each   = github_repository.this
  repository = each.value.name
  # Public repos get vulnerability alerts free on all plans.
  # Private repos require GitHub Advanced Security (Enterprise / Team add-on).
}
