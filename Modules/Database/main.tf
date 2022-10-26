# -------------------------------------------------------------------------------------------------------------
#   ROOT MODULE
# --------------------------------------------------------------------------------------------------------------
resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "secret_name" {
  name_prefix = "${var.component_name}-reader-instance"
  description = "secret to manage supperuser ${var.username} on reader instance"
}

locals {
  secrete_values = {
    endpoint = aws_db_instance.this.address
    username = var.username
    password = random_password.password.result
    port     = var.port
    db_name  = var.db_name
  }
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret_name.id
  secret_string = jsonencode(local.secrete_values)
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_grp_name
  subnet_ids = [var.db-subnet-az-1a, var.db-subnet-az-1b]

  tags = {
    Name = "DB_subnet_group"
  }
}


resource "aws_db_instance" "this" {
  allocated_storage      = var.storage
  db_name                = var.db_name
  engine                 = var.engine_type
  instance_class         = var.instance_class
  username               = var.username
  password               = random_password.password.result
  port                   = var.port
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_SG.id]
}
