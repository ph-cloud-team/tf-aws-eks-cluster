variable "name" {
  description = "EKS cluster name."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9-_]{1,98}[A-Za-z0-9]$", var.name))
    error_message = "name must be a valid EKS cluster name between 3 and 100 characters."
  }
}

variable "cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane."
  type        = string

  validation {
    condition     = can(regex(format("^%s:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", "arn"), var.cluster_role_arn))
    error_message = "cluster_role_arn must be an IAM role ARN."
  }
}

variable "kubernetes_version" {
  description = "Approved Kubernetes minor version for the EKS cluster."
  type        = string
  default     = "1.34"

  validation {
    condition     = contains(["1.33", "1.34", "1.35"], var.kubernetes_version)
    error_message = "kubernetes_version must be one of 1.33, 1.34, or 1.35."
  }
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS control plane ENIs."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "subnet_ids must include at least two subnets."
  }
}

variable "security_group_ids" {
  description = "Security group IDs attached to the EKS control plane."
  type        = list(string)
  default     = []
}

variable "endpoint_private_access" {
  description = "Enable private Kubernetes API endpoint access."
  type        = bool
  default     = true

  validation {
    condition     = var.endpoint_private_access
    error_message = "endpoint_private_access must be true."
  }
}

variable "endpoint_public_access" {
  description = "Enable public Kubernetes API endpoint access. Use only for controlled bootstrap/lab access."
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "Public Kubernetes API allowlist CIDRs. Required as /32 values when public endpoint access is enabled."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.public_access_cidrs :
      can(regex(".*/32$", cidr)) && cidr != "0.0.0.0/0"
    ])
    error_message = "public_access_cidrs must contain only IPv4 /32 CIDRs and must not include 0.0.0.0/0."
  }
}

variable "enabled_cluster_log_types" {
  description = "EKS control plane log types. Platform policy requires all five log types."
  type        = list(string)
  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  validation {
    condition = alltrue([
      for log_type in ["api", "audit", "authenticator", "controllerManager", "scheduler"] :
      contains(var.enabled_cluster_log_types, log_type)
    ])
    error_message = "enabled_cluster_log_types must include api, audit, authenticator, controllerManager, and scheduler."
  }
}

variable "secrets_kms_key_arn" {
  description = "Customer-managed KMS key ARN for Kubernetes secrets encryption."
  type        = string

  validation {
    condition     = can(regex(format("^%s:aws[a-zA-Z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/.+", "arn"), var.secrets_kms_key_arn))
    error_message = "secrets_kms_key_arn must be a KMS key ARN."
  }
}

variable "authentication_mode" {
  description = "EKS access management authentication mode."
  type        = string
  default     = "API_AND_CONFIG_MAP"

  validation {
    condition     = contains(["CONFIG_MAP", "API", "API_AND_CONFIG_MAP"], var.authentication_mode)
    error_message = "authentication_mode must be CONFIG_MAP, API, or API_AND_CONFIG_MAP."
  }
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Grant cluster creator admin permissions. Enterprise baseline keeps this false and uses access entries."
  type        = bool
  default     = false
}

variable "service_ipv4_cidr" {
  description = "Optional Kubernetes service IPv4 CIDR."
  type        = string
  default     = null
}

variable "ip_family" {
  description = "Kubernetes service IP family."
  type        = string
  default     = "ipv4"

  validation {
    condition     = contains(["ipv4", "ipv6"], var.ip_family)
    error_message = "ip_family must be ipv4 or ipv6."
  }
}

variable "upgrade_support_type" {
  description = "EKS upgrade support type."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.upgrade_support_type)
    error_message = "upgrade_support_type must be STANDARD or EXTENDED."
  }
}

variable "create_oidc_provider" {
  description = "Create IAM OIDC provider for IRSA."
  type        = bool
  default     = true
}

variable "oidc_client_id_list" {
  description = "OIDC client IDs for the IAM OIDC provider."
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}

variable "access_entries" {
  description = "EKS access entries and optional policy associations."
  type = map(object({
    principal_arn     = string
    type              = optional(string, "STANDARD")
    kubernetes_groups = optional(list(string), [])
    user_name         = optional(string)
    policy_associations = optional(map(object({
      policy_arn = string
      access_scope = object({
        type       = string
        namespaces = optional(list(string), [])
      })
    })), {})
  }))
  default = {}
}

variable "tags" {
  description = "Common tags to apply to supported AWS resources."
  type        = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "Environment"),
      contains(keys(var.tags), "Owner"),
      contains(keys(var.tags), "CostCenter"),
      contains(keys(var.tags), "Application"),
      contains(keys(var.tags), "DataClassification")
    ])
    error_message = "tags must include Environment, Owner, CostCenter, Application, and DataClassification."
  }
}
