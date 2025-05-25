#DB Subnet Group / need to associate Subnet to DB
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_b.id]
}

#DB Instance
resource "aws_db_instance" "rds" {
  db_name                = "dbtest"
  allocated_storage      = 10
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = "test"
  password               = "bananastest"
  skip_final_snapshot    = true #to be able to destroy it
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name #associate Subnets to instance | needs at least 2 subnets
  publicly_accessible    = false
}

