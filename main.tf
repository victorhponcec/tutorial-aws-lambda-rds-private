provider "aws" {
  region = "us-east-1"
}

#VPC 
resource "aws_vpc" "main" {
  cidr_block           = "10.111.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

#Subnet Private 
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.111.1.0/24"
  availability_zone = "us-east-1a"
}
#Subnet Private B
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.111.2.0/24"
  availability_zone = "us-east-1b"
}

#Private Route Table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.111.0.0/16"
    gateway_id = "local"
  }
}

#Private Route Table B
resource "aws_route_table" "private_rtb_b" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.111.0.0/16"
    gateway_id = "local"
  }
}

#Associate private Subnet to private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rtb.id
}
resource "aws_route_table_association" "private_rtb_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_rtb_b.id
} 