output "cluster_name" {
  description = "K3d cluster name"
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
