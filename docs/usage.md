# Usage

## Private Cluster Baseline

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

## Controlled Lab Bootstrap Public Access

```hcl
endpoint_private_access = true
endpoint_public_access  = true
public_access_cidrs     = ["73.115.41.87/32"]
```

Use this only while the local GitLab runner and AWX controller do not have private network path to the cluster API.
