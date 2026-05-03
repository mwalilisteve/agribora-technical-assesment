output "bucket_name" {
  description = "DO Spaces bucket name for remote state"
  value       = digitalocean_spaces_bucket.state.name
}

output "bucket_region" {
  description = "DO region of the Spaces bucket"
  value       = digitalocean_spaces_bucket.state.region
}

output "bucket_endpoint" {
  description = "S3-compatible endpoint for use in backend config"
  value       = "https://${digitalocean_spaces_bucket.state.region}.digitaloceanspaces.com"
}
