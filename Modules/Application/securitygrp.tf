# -------------------------------------------------------------------------------------------------------------
#   ROOT MODULE
# --------------------------------------------------------------------------------------------------------------
# create SG for the app_load_balancer

resource "aws_security_group" "app_lb_SG" {
  name        = "lb_SG"
  description = "enable http/https access on port 80"
  vpc_id      = var.vpc_id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  
  }

  tags = {
    Name = "app_lb_SG"
  }
}