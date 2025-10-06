data "aws_secretsmanager_secret" "db_password_secret" {
  name = "db_pwd"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password_secret.id
}

data "aws_secretsmanager_secret" "db_username_secret" {
  name = "db_username"
}

data "aws_secretsmanager_secret_version" "db_username" {
  secret_id = data.aws_secretsmanager_secret.db_username_secret.id
}
