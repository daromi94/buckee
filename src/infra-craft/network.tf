resource "aws_vpc" "buckee" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "buckee_a" {
  vpc_id            = aws_vpc.buckee.id
  cidr_block        = "172.16.0.0/20"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "buckee_b" {
  vpc_id            = aws_vpc.buckee.id
  cidr_block        = "172.16.16.0/20"
  availability_zone = "us-east-1b"
}
