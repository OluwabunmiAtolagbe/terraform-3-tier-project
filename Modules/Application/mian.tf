# -------------------------------------------------------------------------------------------------------------
#   ROOT MODULE
# --------------------------------------------------------------------------------------------------------------

# Create ec2 Instances

resource "aws_instance" "this" {
  count = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id = var.ec2_subnet_id_AZ1
  user_data = var.user_data
 
  tags = {
    Name = "app-tier-${count.index + 1}"
  }
}
 
resource "aws_lb_target_group_attachment" "alb_attachment" {
   count  = var.instance_count
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.this[count.index].id
  port             = var.target_port # 
}



/*
resource "aws_instance" "AZ2_Group" {
  count = 3
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.ec2_subnet_id_AZ2

  tags = {
    Name = var.ec2_name_tag
  }
}


resource "aws_instance" "bastion_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.ec2_subnet_id_bastion
  associate_public_ip_address = true

  tags = {
    Name = "bastion_ec2"
  }
}
*/

