module "cluster" {
  source = "../../modules/k3d"

  cluster_name = var.cluster_name
  k3s_image    = var.k3s_image
  servers      = var.servers
  agents       = var.agents
  api_port     = var.api_port
  http_port    = var.http_port
  https_port   = var.https_port
}

module "flux_bootstrap" {
  source = "../../modules/flux-bootstrap"

  depends_on = [module.cluster]

  github_owner    = var.github_owner
  github_token    = var.github_token
  repository_name = var.flux_repository_name
  target_path     = var.flux_target_path
  flux_namespace  = var.flux_namespace
  flux_version    = var.flux_version
}
