variable "cluster_name" {
  description = "Name of the DOKS cluster"
  type        = string
}

variable "region" {
  description = "DigitalOcean region for the cluster (e.g. ams3, nyc1, fra1)"
  type        = string
  default     = "ams3"
}

variable "k8s_version" {
  description = "Kubernetes version slug (use `doctl kubernetes options versions` to list)"
  type        = string
  default     = "1.29.1-do.0"
}

variable "node_size" {
  description = "Droplet size slug for worker nodes (e.g. s-2vcpu-4gb)"
  type        = string
  default     = "s-2vcpu-4gb"
}

variable "node_count" {
  description = "Number of worker nodes in the default node pool"
  type        = number
  default     = 2
}

variable "auto_upgrade" {
  description = "Enable automatic Kubernetes patch version upgrades"
  type        = bool
  default     = true
}
