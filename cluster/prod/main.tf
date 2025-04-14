module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4" # Make sure to check for the latest version
  cluster_name    = "matrix-dev"
  cluster_version = "1.29"

  subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  vpc_id             = "vpc-0abcd1234efgh5678"

  enable_irsa        = true
  manage_aws_auth    = true

  eks_managed_node_groups = {
    default = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "matrix"
  }
}
