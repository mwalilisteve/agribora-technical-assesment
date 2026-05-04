# Agribora GitOps Infrastructure

A fully automated GitOps platform running on a local k3d Kubernetes cluster, bootstrapped with Terraform, managed by Flux CD, and deploying applications via ArgoCD.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Developer Machine                        │
│                                                                 │
│   terraform apply                                               │
│        │                                                        │
│        ▼                                                        │
│   ┌─────────┐     ┌──────────────────────────────────────────┐  │
│   │  k3d    │     │           flux-infra (Git Repo)          │  │
│   │ Cluster │◄────│  clusters/local/                         │  │
│   └─────────┘     │    ├── flux-system/   (Flux bootstrap)   │  │
│        │          │    ├── infrastructure/ (Helm releases)   │  │
│        │          │    └── infrastructure.yaml (Flux CRs)    │  │
│        │          └──────────────────────────────────────────┘  │
│        │                           │                            │
│        ▼                           ▼                            │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │                    k3d Cluster                          │   │
│   │                                                         │   │
│   │  flux-system     → Watches fleet-infra repo             │   │
│   │  traefik         → Ingress Controller                   │   │
│   │  argocd          → Application Deployment               │   │
│   │  vault           → Secrets Storage                      │   │
│   │  external-secrets→ Secrets Sync (ESO)                   │   │
│   │  gitea-app       → Application Workload                 │   │
│   │    ├── gitea     → Git Server Frontend                  │   │
│   │    ├── postgres  → Database                             │   │
│   │    └── redis     → Cache                                │   │
│   └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Repository Structure

This setup uses **3 Git repositories**:

| Repo | Purpose |
|---|---|
| `terraform` | Provisions k3d cluster and bootstraps Flux |
| `flux-infra` | Flux GitOps repo — manages all infrastructure |
| `agribora-sample-app` | Application manifests deployed by ArgoCD |

```
terraform/
├── README.md
├── .gitignore
├── modules/
│   ├── flux-bootstrap/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── providers.tf
│   │   └── outputs.tf
│   │
│   ├── do-spaces/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── providers.tf
│   │   └── outputs.tf
│   │
│   ├── k3d/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── providers.tf
│   │   └── outputs.tf
│   │
│   └── doks/
│       ├── main.tf
│       ├── variables.tf
│       ├── providers.tf
│       └── outputs.tf
│
└── environments/
    ├── production/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── providers.tf
    │   ├── terraform.tfvars
    │   ├── outputs.tf
    │   └── secrets.tfvars
    │
    └── local/
        ├── main.tf
        ├── variables.tf
        ├── providers.tf
        ├── terraform.tfvars
        ├── outputs.tf
        └── secrets.tfvars

flux-infra/
└── clusters/
    └── local/
        ├── flux-system/            ← managed by Flux bootstrap
        ├── infrastructure.yaml     ← Flux Kustomization CRs
        ├── kustomization.yaml      ← plain kustomize, references above
        └── infrastructure/
            ├── traefik/            ← Traefik Helm release
            ├── argocd/             ← ArgoCD Helm release
            ├── vault/              ← Vault Helm release
            ├── external-secrets/   ← ESO Helm release
            └── argocd-apps/        ← ArgoCD Application CRs

app-repo/
└── sample-app/
    ├── kustomization.yaml
    ├── namespace.yaml
    ├── storageclass.yaml
    ├── secrets/
    │   ├── secret-store.yaml       ← ESO SecretStore (connects to Vault)
    │   └── external-secret.yaml    ← ESO ExternalSecret (fetches from Vault)
    ├── network-policies/           ← Kubernetes NetworkPolicies
    ├── database/                   ← PostgreSQL StatefulSet
    ├── redis/                      ← Redis Deployment
    ├── gitea/                      ← Gitea Deployment
    └── ingress/                    ← Traefik IngressRoute
```

---

## Prerequisites

### Required Tools

| Tool |
- Docker Desktop 
- k3d | v5.x 
- kubectl 
- Terraform 
- Flux CLI 
- Vault CLI 
- ArgoCD CLI 


### GitHub Requirements

- A GitHub Personal Access Token (PAT) with `repo` scope
- An existing GitHub repository for `fleet-infra` (the Flux GitOps repo)

---

## Deployment

### Step 1 — Clone the Terraform Repo

```bash
git clone https://github.com/mwalilisteve/agribora-technical-assesment/tree/main/terraform
cd terraform/environments/local
```

### Step 2 — Configure Variables

Create `terraform.tfvars`:

```hcl
# K3d Cluster
cluster_name = "local-dev"
k3s_image    = "rancher/k3s:v1.29.0-k3s1"
servers      = 1
agents       = 1
api_port     = 6443
http_port    = 8080
https_port   = 8443

# Flux Bootstrap
github_owner         = "your-github-username"
flux_repository_name = "flux-infra"
flux_target_path     = "clusters/local"
flux_namespace       = "flux-system"
flux_version         = "v2.8.6"
```

Create `secrets.tfvars` (never commit this file):

```hcl
github_token = "xxxxxxxxx"
```

Add to `.gitignore`:

```
secrets.tfvars
*.tfvars.backup
.terraform/
.terraform.lock.hcl
```

### Step 3 — Initialize and Apply Terraform

```bash
terraform init
terraform plan -var-file="terraform.tfvars" -var-file="secrets.tfvars"
terraform apply -var-file="terraform.tfvars" -var-file="secrets.tfvars"
```

Terraform will:
1. Create a k3d cluster with 1 server and 1 agent node
2. Configure port mappings (API: 6443, HTTP: 8080, HTTPS: 8443)
3. Bootstrap Flux onto the cluster connected to your `fleet-infra` repo

### Step 4 — Update kubeconfig

```bash
k3d kubeconfig merge local-dev --kubeconfig-switch-context
kubectl get nodes    # verify cluster is accessible
```

### Step 5 — Watch the Deployment

```bash
# Watch Flux reconcile everything
flux get kustomizations --watch

# Watch Helm releases come up
flux get helmreleases -A --watch

# Watch all pods
kubectl get pods -A --watch
```

### Step 6 — Seed Secrets into Vault

Once Vault is running:

```bash
# Wait for vault pod
kubectl get pods -n vault

# Port-forward vault
kubectl port-forward svc/vault -n vault 8200:8200 &

# Configure vault
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=root

# Store application secrets
vault kv put secret/gitea \
  POSTGRES_DB=gitea \
  POSTGRES_USER=gitea \
  POSTGRES_PASSWORD=gitea \
  SECRET_KEY=your-secret-key-32chars-minimum \
  INTERNAL_TOKEN=your-internal-token-32chars

# Store ArgoCD Secrets
vault kv put secret/argocd/my-repo \
  username="username" \
  password="your-new-token"

# Verify
vault kv get secret/gitea
```

### Step 7 — Sync ArgoCD Application

Once ArgoCD is running:

```bash
# Port-forward ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8888:80 &

# Get admin password
PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d)

# Login
argocd login localhost:8888 --username admin --password $PASSWORD --insecure

# Create & Sync the app
argocd app create gitea-app \
  --repo https://github.com/mwalilisteve/agribora-technical-assesment \
  --path agribora-sample-app/sample-app \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace gitea-app \
  --project default \
  --sync-policy automated

argocd app sync gitea-app
```

After the first sync, ArgoCD will automatically sync on every subsequent change.

---

## Deployment Flow

```
terraform apply
      │
      ├─► k3d cluster created
      │
      └─► Flux bootstrapped → watches fleet-infra repo
                │
                ▼
         flux-system kustomization reconciles
                │
                ├─► infra-traefik    ──► Traefik HelmRelease (Ready)
                │                              │
                ├─► infra-vault      ──► Vault HelmRelease (Ready)
                │                              │
                ├─► infra-external-secrets ──► ESO HelmRelease (Ready)
                │                              │
                └─► infra-argocd    ──► ArgoCD HelmRelease (Ready)
                         │               (dependsOn: infra-traefik)
                         │
                         ▼
                   argocd-apps ──► applies gitea-app.yaml
                         │         (dependsOn: infra-argocd)
                         │
                         ▼
                   ArgoCD sees Application CR
                         │
                         ▼
                   Deploys app-repo manifests
                         │
                         ├─► gitea-app namespace created
                         ├─► NetworkPolicies applied
                         ├─► ESO ExternalSecret → fetches from Vault
                         │         └─► creates postgres-secret in k8s
                         ├─► PostgreSQL StatefulSet (with PVC)
                         ├─► Redis Deployment (with PVC)
                         └─► Gitea Deployment
                                   └─► Traefik IngressRoute
```

---

## What Gets Deployed

### Infrastructure (managed by Flux)

| Component | Namespace | Purpose |
|---|---|---|
| Flux CD | `flux-system` | GitOps controller, watches fleet-infra repo |
| Traefik | `traefik` | Ingress controller, routes external traffic |
| ArgoCD | `argocd` | Application deployment controller |
| Vault | `vault` | Secrets storage (dev mode for local) |
| External Secrets Operator | `external-secrets` | Syncs secrets from Vault to Kubernetes |

### Application (managed by ArgoCD)

| Component | Namespace | Purpose |
|---|---|---|
| Gitea | `gitea-app` | Git server frontend (port 3000) |
| PostgreSQL | `gitea-app` | Database with persistent storage |
| Redis | `gitea-app` | Cache and session store |
| NetworkPolicies | `gitea-app` | Traffic isolation rules |

---

## Security

### Secret Management Flow

```
Vault (stores plaintext secrets)
      │
      ▼
ESO SecretStore (authenticated connection to Vault)
      │
      ▼
ExternalSecret (defines which secrets to fetch)
      │
      ▼
Kubernetes Secret (created automatically by ESO)
      │
      ▼
Pod (consumes secret via envFrom)
```

No secrets are ever stored in Git.

### Network Policies

| Rule | Effect |
|---|---|
| Default deny all | All traffic in `gitea-app` namespace is blocked by default |
| Allow Traefik → Gitea | Only Traefik pods can reach Gitea on port 3000 |
| Allow Gitea → Postgres | Only Gitea pods can reach Postgres on port 5432 |
| Allow Gitea → Redis | Only Gitea pods can reach Redis on port 6379 |
| Allow DNS | All pods can resolve DNS via kube-system |

---

## Accessing Services

### Gitea
```bash
# Add to /etc/hosts
echo "127.0.0.1 gitea.local" | sudo tee -a /etc/hosts

# Access via browser
open http://gitea.local:8080
```

### ArgoCD UI
```bash
kubectl port-forward svc/argocd-server -n argocd 8888:80 &
open http://localhost:8888

# Get password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d
```

### Vault UI
```bash
kubectl port-forward svc/vault -n vault 8200:8200 &
open http://localhost:8200
# Token: root
```

---

## Teardown

```bash
# Destroy cluster and Flux bootstrap
terraform destroy -var-file="terraform.tfvars" -var-file="secrets.tfvars"
```

> **Note:** The `fleet-infra` GitHub repository is **not** managed by Terraform and will **not** be deleted on destroy. Only the k3d cluster and Flux bootstrap are removed.

---

## Troubleshooting

### kubectl not connecting
```bash
k3d kubeconfig merge local-dev --kubeconfig-switch-context
kubectl cluster-info
```

### Flux not reconciling
```bash
flux check
flux reconcile source git flux-system
flux logs --follow
```

### HelmRelease timeout
```bash
flux suspend helmrelease <name> -n <namespace>
flux resume helmrelease <name> -n <namespace>
flux get helmreleases -A --watch
```

### ArgoCD app not syncing
```bash
argocd app get gitea-app
argocd app sync gitea-app
kubectl get pods -n gitea-app
```

### Namespace stuck terminating
```bash
kubectl patch namespace <name> -p '{"metadata":{"finalizers":[]}}' --type=merge
```

### Check all kustomization health
```bash
flux get kustomizations
flux get helmreleases -A
kubectl get pods -A
```
