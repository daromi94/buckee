variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "private_availability_zones" {
  type        = list(string)
  description = "List of availability zones for private subnets"
}
