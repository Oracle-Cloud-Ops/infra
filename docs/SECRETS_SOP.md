# 🔐 Environment Variables & Secrets SOP

This guide covers how to sync your local `.env` files with the Kubernetes cluster.

---

## 🛠 1. Public Settings (ConfigMaps)
Use this for non-sensitive data like API URLs, Log Levels, or Feature Flags.

**To update from your local `.env`:**
```bash
kubectl create configmap app-config --from-env-file=.env -o yaml --dry-run=client | kubectl apply -f -
```

## 🤫 2. Sensitive Data (Secrets)
Use this for passwords, API keys, tokens, or any PII. Unlike ConfigMaps, Secrets are stored in a way that allows for tighter access control and encryption at rest.

**To update from your local `.env.secrets`:**
```bash
kubectl create secret generic app-secrets --from-env-file=.env.secrets -o yaml --dry-run=client | kubectl apply -f -
```

Markdown
---

## 🏗 3. Injecting into Deployments
To make these variables available to your application, you must map them in your `deployment.yaml`. Using `envFrom` is the most efficient way to sync an entire file's worth of variables at once.

**Example Deployment Snippet:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
spec:
  template:
    spec:
      containers:
        - name: app-container
          image: your-repo/app:latest
          envFrom:
            - configMapRef:
                name: app-config
            - secretRef:
                name: app-secrets
```

---

## 🔄 4. Applying Changes (The "Restart" Rule)
Kubernetes does **not** automatically restart your pods when a ConfigMap or Secret is updated. To pick up the new values, you must trigger a rolling restart.

**To restart your deployment:**
```bash
kubectl rollout restart deployment app-deployment
```

**To verify the variables are loaded:**
```bash
# Replace <pod-name> with your actual pod ID
kubectl exec -it <pod-name> -- printenv | grep MY_VARIABLE_NAME
```

---

## ⚠️ 5. Critical Best Practices

* **Never commit `.env` files:** Ensure all local environment files are added to your `.gitignore`. Only commit `.env.example` templates to the repository.
* **Prefixing:** Use specific prefixes for your keys (e.g., `APP_PORT` vs `PORT`) to avoid collisions with system-level environment variables or other services.
* **Least Privilege:** Only mount the specific secrets or configs that the service actually needs. Avoid mapping an entire secret file if only one key is required.
* **Size Limit:** Remember that ConfigMaps and Secrets have a **1MB limit**. If your configuration exceeds this, consider mounting it as a volume or using an external secret management service like HashiCorp Vault or AWS Secrets Manager.
* **Immutable Flag:** For critical production configurations that should not change during the lifecycle of the resource, consider adding `immutable: true` to the metadata to prevent accidental manual updates.

---

## 🛠 Troubleshooting

| Issue | Potential Cause | Solution |
| :--- | :--- | :--- |
| **Pod CrashLoopBackOff** | Missing required variable or syntax error in `.env` | Run `kubectl describe pod <pod-id>` to check for mount errors. |
| **Old values persisting** | Deployment wasn't restarted | Run `kubectl rollout restart` as shown in Section 4. |
| **Base64 Errors** | Manual edits to Secrets | Ensure values are Base64 encoded if using `kubectl edit`. (Using the `from-env-file` command handles this for you). |
