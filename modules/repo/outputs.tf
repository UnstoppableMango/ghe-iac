output "name" {
  description = "Repository name"
  value       = github_repository.this.name
}

output "html_url" {
  description = "URL to the repository on GitHub"
  value       = github_repository.this.html_url
}

output "full_name" {
  description = "org/repo slug"
  value       = github_repository.this.full_name
}
