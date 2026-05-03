# ── DigitalOcean ──────────────────────────────────────────────────────────────
region = "ams3"

# ── DOKS ──────────────────────────────────────────────────────────────────────
cluster_name = "production"
k8s_version  = "1.29.1-do.0"
node_size    = "s-2vcpu-4gb"
node_count   = 2
auto_upgrade = true

# ── Remote State ──────────────────────────────────────────────────────────────
state_bucket_name = "gitops-tf-state"

# ── Flux Bootstrap ────────────────────────────────────────────────────────────
github_owner         = "mwalilisteve"
flux_repository_name = "fleet-infra"
flux_target_path     = "clusters/production"
flux_namespace       = "flux-system"
flux_version         = "v2.8.6"
