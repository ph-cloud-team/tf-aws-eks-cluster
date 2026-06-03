variable "cluster_role_name" {
  description = "EKS control plane role name."
  type        = string
  default     = "dev-eks-cluster-role"
}

variable "subnet_ids" {
  description = "Private subnet IDs for EKS control plane ENIs."
  type        = list(string)
  default     = null
}

variable "security_group_ids" {
  description = "Security group IDs for the EKS control plane."
  type        = list(string)
  default     = null
}

variable "secrets_kms_key_id" {
  description = "KMS key ID for Kubernetes secrets encryption."
  type        = string
  default     = null
}

variable "platform_admin_role_name" {
  description = "Platform admin role name for EKS access entry example."
  type        = string
  default     = "platform-admin-role"
}
