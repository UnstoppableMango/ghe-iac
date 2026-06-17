variable "github_base_url" {
  type        = string
  description = "GHE API base URL, e.g. https://github.example.com/api/v3/"
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
  type        = string
  description = "Enterprise slug shown in GHE admin (Settings > Enterprise overview)"
}

variable "org_billing_email" {
  type        = string
  description = "Billing contact email for the organization"
}
