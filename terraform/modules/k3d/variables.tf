variable "cluster_name" {
  description = "Name of the k3d cluster"
  type        = string
}

variable "k3s_image" {
  description = "K3s image version to use"
  type        = string
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
