# 🏛️ Core Infrastructure

This repository manages the "Always Free" OCI Stack. It is the single source of truth for the OKE Cluster and shared services.

## 🚀 Quick Access
- **Terraform:** Managed in `/terraform` (Target: eu-frankfurt-1)
- **K8s Services:** Managed in `/k8s-manifests/system`
- **Docs:** [Upgrade SOP](./docs/UPGRADE_SOP.md) | [Postgres Ops](./docs/POSTGRES_OPS.md) | [SECRETS SOP](./docs/SECRETS_SOP.md)

## 🛠 Usage
### 1. Update Hardware
`cd terraform && terraform apply`

### 2. Update K8s Head
`kubectl apply -f k8s-manifests/system/`

### 3. Deploy/Update Apps
`kubectl apply -f k8s-manifests/apps/`
