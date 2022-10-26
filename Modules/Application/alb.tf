# create Application load_balancer

resource "aws_lb" "app_load_balancer" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.app_lb_SG.id]
  subnets                    = var.alb_subnets_id
  enable_deletion_protection = false

  tags = {
    Environment = "alb_load_balancer"
  }
}

# create Target groups

resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.target_group}-${substr(uuid(), 0, 5)}"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled           = true
    interval          = 300
    path              = var.health_check_path #[ "/app1", "/", "app2"]
    port              = "traffic-port"
    timeout           = 60
    matcher           = 200
    healthy_threshold = 5
  }

  lifecycle {
    ignore_changes = [name]
    create_before_destroy = true
  }
}
# create aws_lb_listener on port 80 with redirect Action

resource "aws_lb_listener" "alb_http_slistener" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# create aws_lb_listener on port 80 with forward Action

resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = module.acm.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

