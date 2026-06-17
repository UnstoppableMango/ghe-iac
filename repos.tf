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

module "repo" {
  source   = "./modules/repo"
  for_each = local.repos

  name        = each.key
  description = each.value.description
  topics      = each.value.topics
}
