
output "eks_cluster_name" {
  description = "EKS cluster name"
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  description = "EKS node security group ID"
  value = module.eks.node_security_group_id
}

output "eks_node_group_names" {
  description = "EKS managed node group names"
  value = keys(module.eks.eks_managed_node_groups)
}

