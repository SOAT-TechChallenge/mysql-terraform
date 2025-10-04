variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "db_password" {
  description = "Senha do banco de dados MySQL"
  type        = string
  sensitive   = true
}

variable "eks_security_group_id" {
  description = "Security Group ID do cluster EKS"
  type        = string
  default     = ""
}
