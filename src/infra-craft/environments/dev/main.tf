module "network" {
  source = "../../modules/network"

  vpc_cidr                   = "10.0.0.0/16"
  private_subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
