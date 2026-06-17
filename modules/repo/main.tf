resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  has_issues   = var.has_issues
  has_projects = var.has_projects
  has_wiki     = var.has_wiki

  topics = var.topics

  # GHE with Advanced Security: additional settings become available, e.g.:
  #   security_and_analysis { advanced_security { status = "enabled" } }
}

resource "github_repository_ruleset" "protect_main" {
  name        = "protect-main"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion                = true
    non_fast_forward        = true
    required_linear_history = true

    dynamic "pull_request" {
      for_each = var.require_pr_reviews ? [1] : []
      content {
        required_approving_review_count = var.required_approving_review_count
        dismiss_stale_reviews_on_push   = var.dismiss_stale_reviews_on_push
        require_last_push_approval      = false
      }
    }
  }
}

resource "github_repository_vulnerability_alerts" "this" {
  count      = var.vulnerability_alerts ? 1 : 0
  repository = github_repository.this.name
  # Public repos get vulnerability alerts free on all plans.
  # Private repos require GitHub Advanced Security (Enterprise / Team add-on).
}
