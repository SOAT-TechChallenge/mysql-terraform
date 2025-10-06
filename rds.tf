resource "aws_db_instance" "mysql_database" {
  identifier            = "tech-challenge-db"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50

  db_name  = "fiap"
  username = jsondecode(data.aws_secretsmanager_secret_version.db_username.secret_string)["db_username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["db_password"]
  port     = 3306


  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  backup_retention_period = 3
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name      = "tech-challenge-mysql"
    Terraform = "true"
    Project   = "techchallenge"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "techchallenge-rds-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name    = "techchallenge-rds-subnet-group"
    Project = "techchallenge"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "techchallenge-rds-sg"
  description = "Security group for RDS MySQL"
  vpc_id      = module.vpc.vpc_id

  # Apenas permissão temporária para seu IP
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "Allow MySQL from your IP (temporary)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name    = "techchallenge-rds-sg"
    Project = "techchallenge"
  }
}

# Regra separada para permitir tráfego do EKS
resource "aws_security_group_rule" "allow_eks" {
  count = var.eks_security_group_id != "" ? 1 : 0

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = var.eks_security_group_id
  description              = "Allow MySQL from EKS cluster"
}
