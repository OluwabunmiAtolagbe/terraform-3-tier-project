# -------------------------------------------------------------------------------------------------------------
#   ROOT MODULE
# --------------------------------------------------------------------------------------------------------------
# route53 variables

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "domain_name" {
    description = "route53 domain name"
    type = string
}

# aws_lb variables

variable "alb_name" {
    description = "app load balancer name"
    type = string
}

variable "alb_subnets_id" {
  description = "alb subnets"
  type = list
}

variable "target_group" {
    type = string
    description = "target group name"
}

variable "instance_type" {
  type = string
  description = "instance type"
}

variable "ami_id" {
    type = string
    description = "AMI ID"
}

variable "cider_block_egress" {
  type = list(string)
  description = "any"
}

variable "ec2_subnet_id_AZ1" {
  type = string
  description = "ec2 subnet id"
}

variable "ec2_subnet_id_AZ2" {
  type = string
  description = "ec2 subnet id"
  default = ""
}

variable "ec2_subnet_id_bastion" {
  type = string
  description = "bastion host subnet id"
    default = ""
}

variable "SG_name" {
  type = string
  description = "EC2 security group"
}

variable "target_port" {
  type = number
  description = "target group attachment"
}

variable "instance_count" {
  type = number
  description = "ec2 instance count."
}

variable "sg_ports" {
  type = map(any)
  description = "SG port"
  default = {}
}

variable "user_data" {
  type = string 
  description = "ec2 user data "

}

variable "subject_alternative_names" {
  type = list 
  description = "ec2 user data "
  default = []
}


variable "health_check_path" {
  type = string 
  description = "alb hhealth check pat"
 default = ""

}


