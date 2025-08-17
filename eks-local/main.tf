module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.1.0"  # module version

  name             = "my-eks-cluster"
  cluster_version  = "1.28"  # correct way to set cluster Kubernetes version

  vpc_config = {
    subnet_ids             = module.vpc.private_subnets
    endpoint_public_access = true
  }

  managed_node_groups = {
    nodes = {
      desired_capacity = 2
      min_capacity     = 1
      max_capacity     = 3
      instance_type    = "t2.small"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
