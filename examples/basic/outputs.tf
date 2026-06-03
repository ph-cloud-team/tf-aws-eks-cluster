output "cluster_name" {
  description = "EKS cluster name."
  value       = module.tf_aws_eks_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = module.tf_aws_eks_cluster.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "IAM OIDC provider ARN."
  value       = module.tf_aws_eks_cluster.oidc_provider_arn
}
