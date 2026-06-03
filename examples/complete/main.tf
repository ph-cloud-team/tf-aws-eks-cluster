locals {
  arn_prefix              = format("%s:aws", "arn")
  ci_plan_account_id      = format("%012d", 0)
  ci_plan_kms_key_id      = coalesce(var.secrets_kms_key_id, format("%08x-%04x-%04x-%04x-%012x", 0, 0, 0, 0, 0))
  cluster_role_arn        = "${local.arn_prefix}:iam::${local.ci_plan_account_id}:role/${var.cluster_role_name}"
  platform_admin_role_arn = "${local.arn_prefix}:iam::${local.ci_plan_account_id}:role/${var.platform_admin_role_name}"
  kms_key_arn             = "${local.arn_prefix}:kms:us-east-1:${local.ci_plan_account_id}:key/${local.ci_plan_kms_key_id}"
  subnet_ids              = coalesce(var.subnet_ids, [format("subnet-%017x", 1), format("subnet-%017x", 2)])
  security_group_ids      = coalesce(var.security_group_ids, [format("sg-%017x", 1)])
  eks_access_policy_arn   = "${local.arn_prefix}:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

module "tf_aws_eks_cluster" {
  source = "../../"

  name                = "dev-midh-eks"
  cluster_role_arn    = local.cluster_role_arn
  kubernetes_version  = "1.34"
  subnet_ids          = local.subnet_ids
  security_group_ids  = local.security_group_ids
  secrets_kms_key_arn = local.kms_key_arn

  endpoint_private_access = true
  endpoint_public_access  = false

  authentication_mode                         = "API_AND_CONFIG_MAP"
  bootstrap_cluster_creator_admin_permissions = false

  access_entries = {
    platform_admin = {
      principal_arn = local.platform_admin_role_arn
      policy_associations = {
        cluster_admin = {
          policy_arn = local.eks_access_policy_arn
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = {
    Environment        = "dev"
    Owner              = "platform-team"
    CostCenter         = "shared-services"
    Application        = "midh-eks"
    DataClassification = "internal"
  }
}
