output "cluster_name" {
  description = "EKS cluster name."
  value       = module.tf_aws_eks_cluster.cluster_name
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = module.tf_aws_eks_cluster.cluster_arn
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = module.tf_aws_eks_cluster.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "IAM OIDC provider ARN."
  value       = module.tf_aws_eks_cluster.oidc_provider_arn
}

output "access_entry_names" {
  description = "EKS access entry keys."
  value       = module.tf_aws_eks_cluster.access_entry_names
}
