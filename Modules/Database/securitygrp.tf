# -------------------------------------------------------------------------------------------------------------
#   ROOT MODULE
# --------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "database_SG" {
  name        = var.db_SG_name
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "database from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.security_groups
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = var.security_groups
  }

  tags = {
    Name = "allow_database"
  }
}
