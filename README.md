# tf-aws-eks-cluster

Enterprise Terraform module for Amazon EKS control plane provisioning.

This module creates the EKS cluster control plane with approved Kubernetes versioning, private endpoint controls, full audit logging, KMS secrets encryption, IAM OIDC provider support for IRSA, and optional EKS access entries.

## What This Module Creates

- EKS cluster.
- Private Kubernetes API endpoint configuration.
- Full control plane logging.
- Kubernetes secrets encryption using customer-managed KMS.
- IAM OIDC provider for IRSA.
- Optional EKS access entries and policy associations.
- Enterprise tags.

## Basic Usage

```hcl
module "eks_cluster" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/containers/tf-aws-eks-cluster.git?ref=v1.0.0"

  name                = "dev-midh-eks"
  cluster_role_arn    = module.eks_cluster_role.role_arn
  kubernetes_version  = "1.34"
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.eks_control_plane_sg.security_group_id]
  secrets_kms_key_arn = module.eks_secrets_kms_key.key_arn

  tags = local.tags
}
```

## Lab Bootstrap Endpoint Exception

For the current local GitLab runner and AWX lab, the complete example enables public endpoint access restricted to `73.115.41.87/32` while private endpoint access remains enabled. This is intentionally documented as a bootstrap exception until GitLab runner and AWX have a private network path to the EKS API.

## Policy Alignment

The module is designed to satisfy central EKS OPA policies:

- approved Kubernetes version only;
- private endpoint access enabled;
- public endpoint only with explicit `/32` bootstrap CIDRs;
- all control plane log types enabled;
- KMS encryption for Kubernetes secrets.

## Documentation

- [Architecture](docs/architecture.md)
- [Security](docs/security.md)
- [Usage](docs/usage.md)
