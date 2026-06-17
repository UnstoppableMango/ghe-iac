locals {
  repos = {
    demo-app = {
      description = "Demo application repository"
      topics      = ["demo", "application"]
    }
    demo-infra = {
      description = "Demo infrastructure repository"
      topics      = ["demo", "infrastructure", "terraform"]
    }
  }
}

resource "github_repository" "this" {
  for_each = local.repos

  name        = each.key
  description = each.value.description
  visibility  = "public"

  has_issues   = true
  has_projects = false
  has_wiki     = false

  topics = each.value.topics

  # GHE with Advanced Security: additional settings become available, e.g.:
  #   security_and_analysis { advanced_security { status = "enabled" } }
}
