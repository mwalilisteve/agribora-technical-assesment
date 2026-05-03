variable "bucket_name" {
  description = "Name of the DO Spaces bucket for Terraform remote state"
  type        = string
  default     = "gitops-tf-state"
}

variable "region" {
  description = "DO region for the Spaces bucket (must match cluster region)"
  type        = string
  default     = "ams3"
}
