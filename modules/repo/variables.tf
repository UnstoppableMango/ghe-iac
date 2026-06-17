variable "name" {
  type        = string
  description = "Repository name"
}

variable "description" {
  type        = string
  default     = ""
  description = "Short description shown on the repo page"
}

variable "topics" {
  type        = list(string)
  default     = []
  description = "GitHub topics for discoverability"
}

variable "visibility" {
  type        = string
  default     = "public"
  description = "public or private. Private repos require Advanced Security for vulnerability alerts."

  validation {
    condition     = contains(["public", "private"], var.visibility)
    error_message = "visibility must be \"public\" or \"private\"."
  }
}

variable "has_issues" {
  type    = bool
  default = true
}

variable "has_projects" {
  type    = bool
  default = false
}

variable "has_wiki" {
  type    = bool
  default = false
}

variable "require_pr_reviews" {
  type        = bool
  default     = true
  description = "Require pull request reviews before merging to the default branch"
}

variable "required_approving_review_count" {
  type        = number
  default     = 1
  description = "Number of approvals required. Ignored when require_pr_reviews is false."
}

variable "dismiss_stale_reviews_on_push" {
  type        = bool
  default     = true
  description = "Dismiss approved reviews when new commits are pushed"
}

variable "vulnerability_alerts" {
  type        = bool
  default     = true
  description = "Enable Dependabot vulnerability alerts. Always free for public repos."
}
