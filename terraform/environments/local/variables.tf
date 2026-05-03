# ── K3d ───────────────────────────────────────────────────────────────────────

variable "cluster_name" {
  description = "Name of the k3d cluster"
  type        = string
  default     = "local-dev"
}

variable "k3s_image" {
  description = "K3s image version to use"
  type        = string
  default     = "rancher/k3s:v1.29.0-k3s1"
}

variable "servers" {
  description = "Number of server (control plane) nodes"
  type        = number
  default     = 1
}

variable "agents" {
  description = "Number of agent (worker) nodes"
  type        = number
  default     = 1
}

variable "api_port" {
  description = "Port to expose the Kubernetes API on localhost"
  type        = number
  default     = 6443
}

variable "http_port" {
  description = "Port to map for HTTP ingress"
  type        = number
  default     = 8080
}

variable "https_port" {
  description = "Port to map for HTTPS ingress"
  type        = number
  default     = 8443
}

# ── Flux Bootstrap ────────────────────────────────────────────────────────────

variable "github_owner" {
  description = "Your personal GitHub username"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token with repo permissions"
  type        = string
  sensitive   = true
}

variable "flux_repository_name" {
  description = "Name of the existing GitHub repository for Flux GitOps"
  type        = string
}

variable "flux_target_path" {
  description = "Path within the repository where Flux manifests will be stored"
  type        = string
  default     = "clusters/local"
}

variable "flux_namespace" {
  description = "Kubernetes namespace where Flux components will be installed"
  type        = string
  default     = "flux-system"
}

variable "flux_version" {
  description = "Version of Flux to bootstrap"
  type        = string
  default     = "v2.3.0"
}
