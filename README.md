# sample-nodejs-gitops

GitOps config for [sample-nodejs](https://github.com/harel2320-dev/sample-nodejs), synced to EKS by ArgoCD.

## Layout

```
platform/               cluster-wide tooling (ArgoCD, ALB controller), installed once
apps/sample-nodejs/     this app's Helm chart + ArgoCD Application CR
```

`apps/sample-nodejs/values.yaml`'s image tag is the only thing CI in the app
repo touches - bumped automatically on every push to `main` there, via a
short-lived, repo-scoped GitHub App token. Everything else here is changed
by hand through a PR.

Structured to scale to a second app later (`apps/<name>/`, sharing the same
`platform/`) without reshaping anything.

## CI

Helm lint + template, and Semgrep SAST, on every push/PR:
```bash
helm lint apps/sample-nodejs
helm template apps/sample-nodejs -f apps/sample-nodejs/values.yaml
```

## Security

- Pod-level: non-root (uid matches the app image's distroless nonroot user), read-only root filesystem, all capabilities dropped, default seccomp profile.
- Platform tooling (ArgoCD, ALB controller) pinned to a dedicated, tainted node group - isolated from the app workload.
- ALB controller IAM policy is AWS's own published minimum policy for the controller, not hand-written.
- TLS terminated at the ALB (ACM cert); app itself sees only plain HTTP inside the cluster.
