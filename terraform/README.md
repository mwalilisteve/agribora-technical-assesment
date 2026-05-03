# Terraform Infrastructure

GitOps-ready Kubernetes infrastructure with a clean local ↔ production pivot path.

## Structure

```
terraform/
├── environments/
│   ├── local/          # k3d — local development cluster
│   └── production/     # DOKS — DigitalOcean Kubernetes Service
└── modules/
    ├── k3d/            # Local cluster (pvotal-tech/k3d provider)
    ├── doks/           # Production cluster (digitalocean provider)
    ├── flux-bootstrap/ # Flux GitOps bootstrap (shared by both envs)
    └── do-spaces/      # DO Spaces bucket for remote state (production only)
```

### The Cluster Interface Contract

`modules/k3d` and `modules/doks` expose **identical output names**:

| Output | Description |
|---|---|
| `cluster_name` | Name of the cluster |
| `kubernetes_host` | Kubernetes API endpoint |
| `client_certificate` | Client cert for auth |
| `client_key` | Client key for auth |
| `cluster_ca_certificate` | Cluster CA cert |

Both environment `providers.tf` files reference `module.cluster.*` — so swapping
the cluster backend requires changing only the module source in `main.tf`.

---

## Local Development

### Prerequisites
- [k3d](https://k3d.io/) and Docker
- Terraform >= 1.6.0

### Usage

```bash
cd environments/local

terraform init
terraform apply -var-file="terraform.tfvars" -var-file="secrets.tfvars"
```

Where `secrets.tfvars` contains:
```hcl
github_token = "ghp_..."
```

---

## Production (DOKS)

### Prerequisites
- A DigitalOcean account with a Personal Access Token
- DO Spaces access key + secret key (for remote state)
- Terraform >= 1.6.0

### Step 1 — Export credentials

```bash
export DIGITALOCEAN_TOKEN="dop_v1_..."
export AWS_ACCESS_KEY_ID="<DO Spaces access key>"
export AWS_SECRET_ACCESS_KEY="<DO Spaces secret key>"
```

### Step 2 — Provision the remote state bucket first

```bash
cd environments/production

# Temporarily use local state to create the bucket
terraform init -backend=false
terraform apply -target=module.state_bucket \
  -var-file="terraform.tfvars" -var-file="secrets.tfvars"
```

### Step 3 — Re-init with remote backend

```bash
terraform init   # will prompt to migrate state to DO Spaces
```

### Step 4 — Apply everything

```bash
terraform apply -var-file="terraform.tfvars" -var-file="secrets.tfvars"
```

---

## Switching Flux target path

When promoting from local to production, Flux writes manifests to a different
path in your GitOps repo:

| Environment | `flux_target_path` |
|---|---|
| local | `clusters/local` |
| production | `clusters/production` |

Update `terraform.tfvars` in each environment accordingly.

---

## Secrets

Never commit `secrets.tfvars`. It is listed in `.gitignore`.
Use environment variables or a secrets manager (e.g. Vault, 1Password) for CI.
