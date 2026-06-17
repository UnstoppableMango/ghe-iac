# ghe-iac

Terraform (OpenTofu) demo for managing GitHub organizations via IaC.

## Goals

1. **Functional on GitHub free orgs** — all resources apply and can be tested without a paid plan.
2. **Demonstrate the GitHub Enterprise migration path** — enterprise-only resources are present but gated; comments explain what changes and why.

## Free vs Enterprise pattern

`var.enterprise_slug` is the gate. Set to `null` (default) for github.com free/team orgs. Set to an enterprise slug to activate enterprise-scoped resources.

```hcl
count = var.enterprise_slug != null ? 1 : 0
```

The structural difference: on enterprise, the **org itself is provisioned by IaC** (`github_enterprise_organization`). On free, the org must pre-exist and `var.github_owner` points at it.

## File map

| File | Purpose |
|---|---|
| `terraform.tf` | Provider version constraints |
| `providers.tf` | GitHub provider config — `base_url` null = github.com, set for GHE |
| `variables.tf` | All inputs; enterprise vars default to null |
| `org.tf` | `github_organization_settings` — works on all plans |
| `repos.tf` | `local.repos` map + `module.repo` for_each — single source of truth for all repos |
| `rulesets.tf` | Org-level ruleset (all plans); comments note enterprise policy tier above org |
| `enterprise.tf` | `data.github_enterprise` + `github_enterprise_organization` — both gated on `enterprise_slug` |
| `modules/repo/` | Paved-path module: repo + branch protection ruleset + vulnerability alerts |

## Adding a new repository

Edit `local.repos` in `repos.tf`:

```hcl
locals {
  repos = {
    my-new-repo = {
      description = "What this repo does"
      topics      = ["relevant", "topics"]
    }
  }
}
```

That's it. Branch protection and vulnerability alerts are applied automatically.

For non-default settings, use the module directly:

```hcl
module "repo" {
  source   = "./modules/repo"
  for_each = local.repos

  name                            = each.key
  description                     = each.value.description
  topics                          = each.value.topics
  visibility                      = "private"
  required_approving_review_count = 2
  vulnerability_alerts            = false
}
```

See `modules/repo/variables.tf` for all options.

## Plan requirements by resource

| Resource | Free | Team | Enterprise |
|---|---|---|---|
| `github_repository` | yes | yes | yes |
| `github_repository_vulnerability_alerts` (public repo) | yes | yes | yes |
| `github_repository_vulnerability_alerts` (private repo) | no | no | Advanced Security add-on |
| `github_repository_ruleset` | yes | yes | yes |
| `github_organization_ruleset` | yes | yes | yes |
| `github_organization_settings` | yes | yes | yes |
| `data.github_enterprise` | no | no | yes |
| `github_enterprise_organization` | no | no | yes |

## Usage

```sh
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars — minimum: github_token, github_owner, org_billing_email
tofu init
tofu plan
tofu apply
```

For enterprise, also set `github_base_url`, `enterprise_slug`, and `enterprise_admin_login`.

## Conventions

- New resource types go in their own `.tf` file named after the resource category.
- Enterprise-gated blocks use `count = var.enterprise_slug != null ? 1 : 0` consistently.
- Comments on enterprise-only behavior explain *what* differs and *why* (license requirement, policy tier, etc.) — not just that it's unavailable.
- `local.repos` in `repos.tf` is the single source of truth for repo names; all per-repo resources live inside `modules/repo/`.
- New per-repo resources belong in `modules/repo/main.tf`, not at root level.
