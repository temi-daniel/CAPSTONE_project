
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.eks_cluster_name
  kubernetes_version = "1.36"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  endpoint_public_access  = true
  endpoint_private_access = true

  enable_irsa = true

  addons = {
    vpc-cni = {
      most_recent = true
      before_compute = true
    }
    kube-proxy = {
      most_recent = true
      before_compute = true
    }
    coredns = {
      most_recent = true
    }

  }


  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    nodes = {
      kubernetes_version = "1.36"
      instance_types = [var.node_instance_type]

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size
    }
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
