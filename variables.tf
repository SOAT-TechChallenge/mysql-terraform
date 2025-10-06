variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "eks_security_group_id" {
  description = "Security Group ID do cluster EKS"
  type        = string
  default     = ""
}

variable "your_ip" {
  description = "Seu IP público para acesso temporário"
  type        = string
  default     = ""
}
