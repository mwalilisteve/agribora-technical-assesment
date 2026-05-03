terraform {
  required_version = ">= 1.6.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
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

  # Remote state stored in DO Spaces (S3-compatible).
  # Populate these values after `terraform apply -target=module.state_bucket`.
  # Then run `terraform init` again to migrate local state to the bucket.
  backend "s3" {
    endpoint                    = "https://ams3.digitaloceanspaces.com"
    bucket                      = "gitops-tf-state"   # must match state_bucket_name in tfvars
    key                         = "production/terraform.tfstate"
    region                      = "us-east-1"         # required by S3 protocol; DO ignores this value
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
    # Credentials come from env vars:
    #   AWS_ACCESS_KEY_ID     = DO Spaces access key
    #   AWS_SECRET_ACCESS_KEY = DO Spaces secret key
  }
}

provider "digitalocean" {
  # Token comes from env var: DIGITALOCEAN_TOKEN
}

# The kubernetes and flux providers reference module.cluster.* — the same
# output names used in environments/local, so this block is structurally
# identical to the local providers.tf.
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
