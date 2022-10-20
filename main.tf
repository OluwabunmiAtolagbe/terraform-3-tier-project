# -------------------------------------------------------------------------------------------------------------
#   CHILD'S MODULE
# --------------------------------------------------------------------------------------------------------------
# cALLING Network module 
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
  source = "./Modules/Application" # git

  alb_name           = "albloadbalancer"
  cider_block_egress = ["0.0.0.0/0"]
  domain_name        = "queenietech.com"
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
  target_port               = 80
  instance_count            = 3
  subject_alternative_names = ["*.queenietech.com"]
  user_data                 = file("./templates/app_tier.sh")
  health_check_path         = "/app1/index.html"
}


module "Database" {
  source = "./Modules/Database"

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
  vpc_id          = module.networking.vpc_id
  security_groups = [module.application.app_security_group_id]
 
}



