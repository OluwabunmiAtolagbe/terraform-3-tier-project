# -------------------------------------------------------------------------------------------------------------
#   ROOT MODULE
# --------------------------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_grp_name
  subnet_ids = [var.db-subnet-az-1a, var.db-subnet-az-1b]

  tags = {
    Name = "DB_subnet_group"
  }
}


resource "aws_db_instance" "project_db" {
  allocated_storage    = var.storage
  db_name              = var.db_name
  engine               = var.engine_type
  # engine_version       = ""
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  # parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.database_SG.id]

}







# resource "aws_db_snapshot" "example" {
#   db_instance_identifier = aws_db_instance.example.id
#   db_snapshot_identifier = "testsnapshot1234"
# }