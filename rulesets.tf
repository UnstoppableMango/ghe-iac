# Repo-level rulesets work on all GitHub plans.
resource "github_repository_ruleset" "protect_main" {
  for_each = github_repository.this

  name        = "protect-main"
  repository  = each.value.name
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

    pull_request {
      required_approving_review_count = 1
      dismiss_stale_reviews_on_push   = true
      require_last_push_approval      = false
    }
  }
}

# Org-level rulesets apply to all repositories in the org, including ones created later.
# Works on all github.com plans.
# GHE advantage: enterprise-level policies sit above org-level and cannot be overridden
# by org admins — use github_enterprise_* policy resources for that enforcement tier.
resource "github_organization_ruleset" "protect_main" {
  name        = "org-protect-main"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }

    repository_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true
  }
}
