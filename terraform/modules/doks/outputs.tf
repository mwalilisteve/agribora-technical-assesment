output "cluster_name" {
  description = "Name of the DOKS cluster"
  value       = digitalocean_kubernetes_cluster.this.name
}

output "kubernetes_host" {
  description = "Kubernetes API server endpoint"
  value       = digitalocean_kubernetes_cluster.this.endpoint
}

output "client_certificate" {
  description = "Client certificate for Kubernetes authentication"
  value       = base64decode(digitalocean_kubernetes_cluster.this.kube_config[0].client_certificate)
  sensitive   = true
}

output "client_key" {
  description = "Client key for Kubernetes authentication"
  value       = base64decode(digitalocean_kubernetes_cluster.this.kube_config[0].client_key)
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = base64decode(digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
  sensitive   = true
}
