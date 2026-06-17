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
