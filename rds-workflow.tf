provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "existing_vpc" {
  id = "vpc-0a3cda330a9a42e26"
}

data "aws_subnet" "eks_subnet_1" {
  id = "subnet-0dbdb383d5ba07a45"
}

data "aws_subnet" "eks_subnet_2" {
  id = "subnet-0544755a56596ec7d"
}

data "aws_subnet" "eks_subnet_3" {
  id = "subnet-07f3f69e4421c1991"
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS MySQL"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # ajuste para a rede do EKS
    description = "Allow MySQL from EKS nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "rds-mysql-sg"
    Provider = "Terraform"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"
  subnet_ids = [
    data.aws_subnet.eks_subnet_1.id,
    data.aws_subnet.eks_subnet_2.id
  ]

  tags = {
    Name     = "RDS Subnet Group"
    Provider = "Terraform"
  }
}

resource "aws_db_instance" "mysql_database" {
  identifier            = "tech-challenge-db"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50

  db_name  = "fiap"
  username = "admin"
  password = "root12345"
  port     = 3306

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  backup_retention_period = 3
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name     = "tech-challenge-mysql"
    Provider = "Terraform"
  }
}
