#Security group RDS
resource "aws_security_group" "rds" {
  name        = "rds"
  description = "allow SSH (for EC2 instance)"
  vpc_id      = aws_vpc.main.id
}

#Ingress rule for VPC
resource "aws_vpc_security_group_ingress_rule" "allow_rds_vpc" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4         = "10.111.0.0/16" #change for VPC CIDR "10.111.0.0/16" or SG of EC2 
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
}
#Ingress rule for Lambda
resource "aws_vpc_security_group_ingress_rule" "allow_lambda" {
  security_group_id = aws_security_group.rds.id
  #cidr_ipv4         = "0.0.0.0/0"
  referenced_security_group_id = aws_security_group.lambda.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}
#Egress rule
resource "aws_vpc_security_group_egress_rule" "egress_rds" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

#Security group Lambda
resource "aws_security_group" "lambda" {
  name        = "lambda"
  description = "allow SSH (for EC2 instance)"
  vpc_id      = aws_vpc.main.id
}
/*
#Ingress rule for SSH | INGRESS RULES ARE NOT NECESSARY FOR LAMBDA, ONLY EGRESS RULES WHEN LAMBDA IS IN VPC
resource "aws_vpc_security_group_ingress_rule" "allow_rds" {
  security_group_id = aws_security_group.lambda.id
  #cidr_ipv4         = "0.0.0.0/0"
  referenced_security_group_id = aws_security_group.rds.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}*/
#Egress rule
resource "aws_vpc_security_group_egress_rule" "egress_lambda" {
  security_group_id = aws_security_group.lambda.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}