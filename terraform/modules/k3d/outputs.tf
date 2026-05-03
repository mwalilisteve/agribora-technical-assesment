# These output names form the shared "cluster interface contract".
# The modules/doks module must expose identical output names so that
# environments/production can swap in DOKS with zero changes elsewhere.

output "cluster_name" {
  description = "Name of the k3d cluster"
  value       = k3d_cluster.this.name
}

output "kubernetes_host" {
  description = "Kubernetes API server endpoint"
  value       = "https://0.0.0.0:${var.api_port}"
}

output "client_certificate" {
  description = "Client certificate for Kubernetes authentication"
  value       = k3d_cluster.this.credentials[0].client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Client key for Kubernetes authentication"
  value       = k3d_cluster.this.credentials[0].client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = k3d_cluster.this.credentials[0].cluster_ca_certificate
  sensitive   = true
}
