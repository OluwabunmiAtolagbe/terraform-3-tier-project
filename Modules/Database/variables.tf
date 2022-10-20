# -------------------------------------------------------------------------------------------------------------
#   ROOT MODULE
# --------------------------------------------------------------------------------------------------------------

variable "db_SG_name" {
    type = string
    description = "db security group name"
}

variable "db_subnet_grp_name" {
    type = string
    description = "database subnet group"
    # default = "database_subnet_grp"
}

variable "db-subnet-az-1a" {
    type = string
    description = "database subnet ID"
}

variable "db-subnet-az-1b" {
    type = string
    description = "db subnet ID"
}

variable "db_name" {
    type = string
    description = "mysql db name"
    # default = "project_database"
}

variable "storage" {
    type = number
    description = "storage allocation"
    # default = "20"
}

variable "security_groups" {
    type = list(any)
    description = " "
     default = []
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}


variable "engine_type" {
    type = string
    description = "db engine type"
    # default = "mysql"
}

variable "instance_class" {
    type = string
    description = "db instance class"
    # default = "t3.micro"
}

variable "username" {
    type = string
    description = "db username"
}

variable "password" {
    type = string
    description = "db password"
}



