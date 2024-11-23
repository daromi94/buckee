module "network" {
  source                     = "../../modules/network"
  vpc_cidr                   = "172.16.0.0/16"
  private_subnet_cidrs       = ["172.16.0.0/20", "172.16.16.0/20"]
  private_availability_zones = ["us-east-1a", "us-east-1b"]
}
