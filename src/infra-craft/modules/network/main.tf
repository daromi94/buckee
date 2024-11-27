resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.this.id

  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

data "aws_availability_zones" "available" {
  state = "available"
}
