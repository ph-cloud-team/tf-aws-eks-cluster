# Security

EKS control plane security is enforced through endpoint access, encryption, logging, and explicit access management.

## Controls

- Kubernetes version must be approved by platform policy.
- Private endpoint access is required.
- Public endpoint access is disabled for the module compliance baseline.
- Control plane log types are all enabled.
- Kubernetes secrets are encrypted with customer-managed KMS.
- Cluster creator admin bootstrap is disabled by default.
- EKS access entries are explicit.

## Lab Note

The current local lab may temporarily use `endpoint_public_access = true` with `73.115.41.87/32` for GitLab runner and AWX bootstrap access in `tf-live`. That is a live-stack bootstrap exception, not the reusable module compliance baseline, and should move to private network access for production.
