resource "digitalocean_kubernetes_cluster" "this" {
  name    = var.cluster_name
  region  = var.region
  version = var.k8s_version

  node_pool {
    name       = "${var.cluster_name}-pool"
    size       = var.node_size
    node_count = var.node_count

    labels = {
      env = "production"
    }
  }

  # Automatically upgrade patch versions
  auto_upgrade  = var.auto_upgrade
  surge_upgrade = true
}
