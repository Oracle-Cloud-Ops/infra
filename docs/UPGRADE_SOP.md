# 🚨 OKE Kubernetes Upgrade Procedure (Manual Cycle)

**Current Status:** Control Plane v1.35.0 | Node Pool v1.34.2
**Tier:** Always Free (Basic Cluster - No Auto-Cycling)

---

## Pre-Flight Checks
1. [ ] **Backup Database:** Run the backup script in `POSTGRES_OPS.md`.
2. [ ] **Maintenance Mode:** Enable the Cloudflare Worker or point the NLB to the AMD Maintenance Node.
3. [ ] **Verify Quota:** Ensure no other ARM instances are running (Max 4 OCPUs).

## Phase 1: Terraform Update
1. Update `terraform/main.tf`:
   - `kubernetes_version` (Cluster) -> `v1.35.0`
   - `kubernetes_version` (Node Pool) -> `v1.34.2`
   - `image_id` -> [Latest OL8 ARM OCID]
2. Run `terraform plan` to ensure no "Surge" (0) is attempted.
3. Run `terraform apply`.

## Phase 2: The Manual Hardware Cycle
*Since we are on a Basic Cluster, we must trigger the reboot via the Console.*
1. Go to **OCI Console** > **Developer Services** > **Kubernetes Clusters**.
2. Select the Cluster > **Node Pools** > **[Your Node Pool]**.
3. Click **Cycle Nodes**.
4. **Settings:**
   - **Maximum Surge:** 0
   - **Maximum Unavailable:** 1
   - **Method:** Replace Boot Volume
5. Click **Cycle Nodes**.

## Phase 3: Verification
1. [ ] Run `watch kubectl get nodes` until the new node is `Ready`.
2. [ ] Run `kubectl get pods -A` to ensure all system pods are running.
3. [ ] Run `kubectl logs -l app=postgres` to verify DB recovery.
4. [ ] Disable Maintenance Mode.
