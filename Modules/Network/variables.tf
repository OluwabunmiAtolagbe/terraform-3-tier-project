
variable "vpc_name" {
  description = "The name of  vpc "
  type        = string
}

variable "VPC_cider_block" {
  type = string
  # default = "10.0.0.0/16"
}

variable "public_subnet_1a_cider_block" {
  description = "1a public subnet cider block"
  type        = string
  # default = "10.0.10.0/24"
}

variable "private_subnet_1a_cider_block" {
  description = "1a private subnet cider block"
  type        = string
  # default = "10.0.1.0/24"
}

variable "public_subnet_1b_cider_block" {
  description = "1b public subnet cider block"
  type        = string
  # default = "10.0.30.0/24"
}

variable "private_subnet_1b_cider_block" {
  description = "1b private subnet cider block"
  type        = string
  # default = "10.0.60.0/24"
}
