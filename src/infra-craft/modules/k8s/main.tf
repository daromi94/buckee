# Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.cluster]
}

# Cluster Role
resource "aws_iam_role" "cluster" {
  name               = var.cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.eks_trust_policy.json
}

data "aws_iam_policy_document" "eks_trust_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "cluster" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Node Group
resource "aws_eks_node_group" "this" {
  cluster_name  = aws_eks_cluster.this.name
  node_role_arn = aws_iam_role.node_group.arn
  subnet_ids    = var.subnet_ids

  scaling_config {
    min_size     = 1
    max_size     = 2
    desired_size = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node,
    aws_iam_role_policy_attachment.cni,
    aws_iam_role_policy_attachment.ecr,
  ]
}

# Node Group Role
resource "aws_iam_role" "node_group" {
  name               = var.node_group_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_trust_policy.json
}

data "aws_iam_policy_document" "ec2_trust_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "worker_node" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
