locals {
  module_name = "tf-aws-eks-cluster"

  common_tags = merge(
    {
      ManagedBy = "terraform"
      Module    = local.module_name
    },
    var.tags
  )

  access_policy_associations = length(var.access_entries) == 0 ? {} : merge([
    for entry_key, entry in var.access_entries : {
      for policy_key, policy in entry.policy_associations :
      "${entry_key}-${policy_key}" => {
        principal_arn = entry.principal_arn
        policy_arn    = policy.policy_arn
        access_scope  = policy.access_scope
      }
    }
  ]...)
}
