# SSH access from anywhere

resource "aws_security_group" "bastion_SG" {
  name        = var.SG_name
  description = "enable ssh access on port 22"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.app_lb_SG.id]
  }

  # Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cider_block_egress
  }

  tags = {
    Name = "Bastion Host SG"
  }
}

# EC2 security group

resource "aws_security_group" "this" {
  name        = "ec2-sg"
  description = "Ingress for Vault"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.target_port
    to_port     = var.target_port
    protocol    = "tcp"
    cidr_blocks = var.cider_block_egress
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cider_block_egress
  }

  tags = {
    Name = "EC2_SG"
  }
}

