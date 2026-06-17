# Enterprise Cloud / GHE only: this data source requires an enterprise license.
# github.com free/team orgs cannot use it; set enterprise_slug = null to skip.
# On GHE, also set github_base_url to point at your instance.
data "github_enterprise" "this" {
  count = var.enterprise_slug != null ? 1 : 0
  slug  = var.enterprise_slug
}

# Enterprise only: IaC provisions the org itself under the enterprise.
# This is the key structural difference from free-tier — on free, the org must
# already exist and github_owner points at it. On enterprise, the org is created
# here, and the provider's owner would be set to this org's name.
resource "github_enterprise_organization" "demo" {
  count = var.enterprise_slug != null ? 1 : 0

  enterprise_id = data.github_enterprise.this[0].id
  name          = "demo-org"
  display_name  = "Demo Organization"
  description   = "Managed by Terraform"
  billing_email = var.org_billing_email
  admin_logins  = [var.enterprise_admin_login]
}
