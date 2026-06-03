# Architecture

This module owns the EKS control plane and identity endpoints needed by downstream Kubernetes infrastructure.

## Resource Model

- `aws_eks_cluster.this` creates the EKS cluster.
- `aws_iam_openid_connect_provider.this` creates the IAM OIDC provider used by IRSA.
- `aws_eks_access_entry.this` optionally manages EKS API access entries.
- `aws_eks_access_policy_association.this` optionally associates AWS-managed EKS access policies.

## Dependency Flow

Create dependencies before this module:

1. VPC and private subnets.
2. Security group for control plane access.
3. IAM role for EKS control plane.
4. KMS key for Kubernetes secrets encryption.
5. CloudWatch log group standard, if pre-created by the live stack.
6. VPC endpoints for private AWS API access.

After this module:

1. IRSA roles consume `oidc_provider_arn` and `oidc_provider_url`.
2. Managed node group module consumes `cluster_name`.
3. Add-on module consumes cluster identity and optional IRSA roles.
