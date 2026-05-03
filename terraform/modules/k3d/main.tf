resource "k3d_cluster" "this" {
  name    = var.cluster_name
  servers = var.servers
  agents  = var.agents
  image   = var.k3s_image

  kube_api {
    host      = "0.0.0.0"
    host_port = var.api_port
  }

  port {
    host_port      = var.http_port
    container_port = 80
    node_filters   = ["loadbalancer"]
  }

  port {
    host_port      = var.https_port
    container_port = 443
    node_filters   = ["loadbalancer"]
  }

  k3d {
    disable_load_balancer = false
  }

  k3s {
    extra_args {
      arg          = "--disable=traefik"
      node_filters = ["server:0"]
    }
  }

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }
}
