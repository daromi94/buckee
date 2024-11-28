locals {
  default_route_cidr = "0.0.0.0/0"
}

# Availability Zones
data "aws_availability_zones" "this" {
  state = "available"
}

# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
}

# Private Subnets
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.this.names[count.index]

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/role/elb" = "1"
  }
}

# Elastic IP
resource "aws_eip" "this" {
  domain = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[0].id
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = local.default_route_cidr
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = local.default_route_cidr
    gateway_id = aws_internet_gateway.this.id
  }
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
