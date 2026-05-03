output "cluster_name" {
  description = "DOKS cluster name"
  value       = module.cluster.cluster_name
}

output "kubernetes_host" {
  description = "Kubernetes API server endpoint"
  value       = module.cluster.kubernetes_host
}

output "flux_repository_url" {
  description = "HTTPS URL of the Flux GitOps repository"
  value       = module.flux_bootstrap.repository_url
}

output "flux_namespace" {
  description = "Namespace where Flux is installed"
  value       = var.flux_namespace
}

output "state_bucket_name" {
  description = "DO Spaces bucket used for remote state"
  value       = module.state_bucket.bucket_name
}

output "state_bucket_endpoint" {
  description = "S3-compatible endpoint for the remote state bucket"
  value       = module.state_bucket.bucket_endpoint
}
