terraform {
  required_version = ">= 1.6.0"

  required_providers {
    k3d = {
      source  = "pvotal-tech/k3d"
      version = "~> 0.0.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.3"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Local state — fine for dev, no remote backend needed
}

provider "kubernetes" {
  host                   = module.cluster.kubernetes_host
  client_certificate     = module.cluster.client_certificate
  client_key             = module.cluster.client_key
  cluster_ca_certificate = module.cluster.cluster_ca_certificate
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}

provider "flux" {
  kubernetes = {
    host                   = module.cluster.kubernetes_host
    client_certificate     = module.cluster.client_certificate
    client_key             = module.cluster.client_key
    cluster_ca_certificate = module.cluster.cluster_ca_certificate
  }
  git = {
    url = "https://github.com/${var.github_owner}/${var.flux_repository_name}.git"
    http = {
      username = "git"
      password = var.github_token
    }
  }
}
