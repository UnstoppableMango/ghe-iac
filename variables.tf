variable "github_base_url" {
  type        = string
  default     = null
  # GHE only: set to https://github.example.com/api/v3/
  # Leave null for github.com.
  description = "GHE API base URL. Null uses github.com."
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_owner" {
  type        = string
  description = "Organization slug owning the managed resources"
}

variable "enterprise_slug" {
  type    = string
  default = null
  # GHE / Enterprise Cloud only: slug from Settings > Enterprise overview.
  # Leave null for github.com free/team orgs.
  description = "Enterprise slug. Null disables enterprise-scoped resources."
}

variable "org_billing_email" {
  type        = string
  description = "Billing contact email for the organization"
}

variable "enterprise_admin_login" {
  type    = string
  default = null
  # Required when enterprise_slug is set — must be an existing GitHub user.
  description = "GitHub username to assign as org admin on enterprise-provisioned orgs."
}
