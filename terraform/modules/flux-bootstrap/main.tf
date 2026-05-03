resource "flux_bootstrap_git" "this" {
  path      = var.target_path
  namespace = var.flux_namespace
  version   = var.flux_version

  components_extra = [
    "image-reflector-controller",
    "image-automation-controller",
  ]
}
