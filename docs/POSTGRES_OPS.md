# 💾 Postgres Database Operations

This guide covers manual data management for the Postgres instance running in the OKE cluster.

---

## 📥 Manual Backup (Dump)
Run this from your local machine to save a snapshot of the database to your current folder. 
*Note: This uses the label selector `app=postgres` so it works even if the pod name changes.*

```bash
kubectl exec -it $(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}') \
-- pg_dump -U postgres postgres > backup_$(date +%Y%m%d).sql
```

## 📤 Restore from Backup
If you need to wipe the database and start fresh from a backup file:

1. **Copy the backup file into the pod:**
   ```bash
   kubectl cp backup.sql $(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}'):/tmp/backup.sql
   ```
2. **Run the restore command inside the pod:**
   ```bash
   kubectl exec -it $(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}') \
   -- psql -U postgres -d postgres -f /tmp/backup.sql
   ```

---

## 🔍 Troubleshooting Storage
Since we are on a single-node "Always Free" cluster, the Block Volume (PVC) can sometimes get "stuck" during a node cycle because OCI thinks the old node still has it.

**The "Stuck Pending" Fix:**

1. **Check Events:**
   kubectl describe pod -l app=postgres

2. **The Problem:** If you see a "Multi-Attach error", it means the old (terminated) node didn't release the volume fast enough for the new node to grab it.

3. **The Fix:**
   - Go to the **OCI Console** -> **Storage** -> **Block Volumes**.
   - Find your volume (the one associated with your PVC).
   - Click **Attached Instances** in the left sidebar.
   - Manually **Detach** it from the old instance if it is still listed as "Attached".
   - The new node will then pick it up automatically within 60 seconds.

---
*Last Updated: April 2026*
