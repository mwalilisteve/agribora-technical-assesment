# ── DigitalOcean ──────────────────────────────────────────────────────────────

variable "region" {
  description = "DigitalOcean region (e.g. ams3, nyc1, fra1, sgp1)"
  type        = string
  default     = "ams3"
}

# ── DOKS ──────────────────────────────────────────────────────────────────────

variable "cluster_name" {
  description = "Name of the DOKS cluster"
  type        = string
  default     = "production"
}

variable "k8s_version" {
  description = "Kubernetes version slug — run `doctl kubernetes options versions`"
  type        = string
  default     = "1.29.1-do.0"
}

variable "node_size" {
  description = "Droplet size slug for worker nodes — run `doctl kubernetes options sizes`"
  type        = string
  default     = "s-2vcpu-4gb"
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "auto_upgrade" {
  description = "Enable automatic Kubernetes patch version upgrades"
  type        = bool
  default     = true
}

# ── Remote State ──────────────────────────────────────────────────────────────

variable "state_bucket_name" {
  description = "DO Spaces bucket name for Terraform remote state"
  type        = string
  default     = "gitops-tf-state"
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
  default     = "clusters/production"
}

variable "flux_namespace" {
  description = "Kubernetes namespace where Flux components will be installed"
  type        = string
  default     = "flux-system"
}

variable "flux_version" {
  description = "Version of Flux to bootstrap"
  type        = string
  default     = "v2.8.6"
}
