output "repository_url" {
  description = "HTTPS URL of the Flux GitOps repository"
  value       = "https://github.com/${var.github_owner}/${var.repository_name}"
}
