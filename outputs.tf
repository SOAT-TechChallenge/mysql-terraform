output "rds_endpoint" {
  description = "Endpoint do banco de dados RDS"
  value       = aws_db_instance.mysql_database.endpoint
  sensitive   = false
}

output "rds_connection_string" {
  description = "String de conexão JDBC"
  value       = "jdbc:mysql://${aws_db_instance.mysql_database.endpoint}/fiap"
  sensitive   = false
}

output "rds_security_group_id" {
  description = "ID do Security Group do RDS"
  value       = aws_security_group.rds_sg.id
}

output "vpc_id" {
  description = "ID da VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.vpc.public_subnets
}