# Step 1: provision the DO Spaces bucket for remote state.
module "state_bucket" {
  source = "../../modules/do-spaces"

  bucket_name = var.state_bucket_name
  region      = var.region
}

# Step 2: provision the DOKS cluster.
module "cluster" {
  source = "../../modules/doks"

  cluster_name = var.cluster_name
  region       = var.region
  k8s_version  = var.k8s_version
  node_size    = var.node_size
  node_count   = var.node_count
  auto_upgrade = var.auto_upgrade
}

# Step 3: bootstrap Flux — identical to the local environment.
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
