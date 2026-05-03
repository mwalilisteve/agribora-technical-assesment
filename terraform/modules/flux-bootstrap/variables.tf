variable "github_owner" {
  description = "Your personal GitHub username"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token with repo permissions"
  type        = string
  sensitive   = true
}

variable "repository_name" {
  description = "Name of the existing GitHub repository for Flux GitOps"
  type        = string
}

variable "target_path" {
  description = "Path within the repository where Flux manifests will be stored"
  type        = string
}

variable "flux_namespace" {
  description = "Kubernetes namespace where Flux will be installed"
  type        = string
  default     = "flux-system"
}
variable "flux_version" {
  description = "Version of Flux to bootstrap"
  type        = string
}
