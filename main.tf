# -------------------------------------------------------------------------------------------------------------
#   CHILD'S MODULE
# --------------------------------------------------------------------------------------------------------------
# cALLING Network module 
locals {
  secrets_value = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)
}

data "aws_secretsmanager_secret_version" "this" {
  depends_on = [module.Database]
  secret_id  = module.Database.secrets_version
}


data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


module "networking" {
  source = "./Modules/Network" # git

  vpc_name                      = "project-vpc"
  VPC_cider_block               = "10.0.0.0/16"
  public_subnet_1a_cider_block  = "10.0.10.0/24"
  private_subnet_1a_cider_block = "10.0.1.0/24"
  public_subnet_1b_cider_block  = "10.0.30.0/24"
  private_subnet_1b_cider_block = "10.0.60.0/24"
}


module "application" {
  # depends_on = [module.Database]
  source = "./Modules/Application" # git

  alb_name           = "albloadbalancer"
  cider_block_egress = ["0.0.0.0/0"]
  domain_name        = "queenietech.click"
  target_group       = "alb-target-group"
  alb_subnets_id = [module.networking.public-subnet-az-1a,
  module.networking.public-subnet-az-1b]
  instance_type             = "t2.micro"
  ami_id                    = data.aws_ami.ami.id
  ec2_subnet_id_AZ1         = module.networking.private-subnet-az-1a
  ec2_subnet_id_AZ2         = module.networking.private-subnet-az-1b
  vpc_id                    = module.networking.vpc_id
  ec2_subnet_id_bastion     = module.networking.public-subnet-az-1b
  SG_name                   = "webapp_SG"
  target_port               = 8080
  instance_count            = 3
  subject_alternative_names = ["*.queenietech.click"]
  # user_data                 = file("./templates/app_tier.sh") # 
  user_data = templatefile("${path.root}/templates/registration_app.tmpl",
    {
      endpoint = local.secrets_value["endpoint"]
      port     = local.secrets_value["port"]
      db_name  = local.secrets_value["db_name"]
      db_user  = local.secrets_value["username"]
      password = local.secrets_value["password"]
    }

  )

  health_check_path = "/login" # 
}


module "Database" {
  source = "./Modules/Database" # "git::?//Modules/Database"

  db_name            = "project_database"
  db_SG_name         = "database_SG"
  db_subnet_grp_name = "database_subnet_grp"
  db-subnet-az-1a    = module.networking.private-subnet-az-1a
  db-subnet-az-1b    = module.networking.private-subnet-az-1b
  storage            = 20
  engine_type        = "mysql"
  instance_class     = "db.t2.micro"
  username           = "admin"
  password           = var.password
  vpc_id             = module.networking.vpc_id
  security_groups    = [module.application.app_security_group_id] # 
  component_name     = "registration-app"
}



