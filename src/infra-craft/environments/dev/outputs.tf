output "vpc_id" {
  value       = module.network.vpc_id
  description = "The ID of the VPC for dev environment"
}

output "private_subnet_ids" {
  value       = module.network.private_subnet_ids
  description = "The IDs of the private subnets for dev environment"
}
