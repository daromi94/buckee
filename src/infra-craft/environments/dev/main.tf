locals {
  project     = "buckee"
  environment = "dev"
}

provider "aws" {
  region = var.region
}

module "network" {
  source = "../../modules/network"

  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidrs  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

module "k8s" {
  source = "../../modules/k8s"

  cluster_name         = "${local.project}-${local.environment}"
  subnet_ids           = module.network.private_subnet_ids
  cluster_role_name    = "${local.project}-${local.environment}-cluster-role"
  node_group_role_name = "${local.project}-${local.environment}-node-group-role"
}
