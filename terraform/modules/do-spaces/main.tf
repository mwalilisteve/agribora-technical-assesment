resource "digitalocean_spaces_bucket" "state" {
  name   = var.bucket_name
  region = var.region
  acl    = "private"

  versioning {
    enabled = true
  }
}
