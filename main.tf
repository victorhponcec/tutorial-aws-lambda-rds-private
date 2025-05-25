#Configuring AWS Provider
provider "aws" {
  region = "us-east-1"
}

#VPC 
resource "aws_vpc" "main" {
  cidr_block           = "10.111.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}
/*
#Subnet Public
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.111.1.0/24"
  availability_zone = "us-east-1a"
}
#Subnet Public B
resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.111.4.0/24"
  availability_zone = "us-east-1b"
}*/

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
/*
#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

#EIP for NAT Gateway
resource "aws_eip" "eip_ngw" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

#NAT Gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip_ngw.id
  subnet_id     = aws_subnet.public_subnet.id #NATGW must be placed in public subnet
  depends_on    = [aws_internet_gateway.igw]
}

#Route Tables
#Public Route table
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}*/

#Private Route Table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.111.0.0/16"
    gateway_id = "local"
  }
}

#Private Route Table
resource "aws_route_table" "private_rtb_b" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.111.0.0/16"
    gateway_id = "local"
  }
}

#Create route table associations
/*
#Associate public Subnet to public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rtb.id
}*/
#Associate private Subnet to private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rtb.id
}
resource "aws_route_table_association" "private_rtb_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_rtb_b.id
} 