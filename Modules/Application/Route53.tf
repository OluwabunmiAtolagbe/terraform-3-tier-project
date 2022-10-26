# -------------------------------------------------------------------------------------------------------------
#   ROOT MODULE
# --------------------------------------------------------------------------------------------------------------
# hosted zone details

data "aws_route53_zone" "hosted_zone" {
  name = "${var.domain_name}."
}

resource "aws_route53_record" "project_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name # www
  type    = "A"             # A contain the record type

  alias {
    name                   = aws_lb.app_load_balancer.dns_name
    zone_id                = aws_lb.app_load_balancer.zone_id
    evaluate_target_health = true
  }
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.0.0"

  domain_name               = trimsuffix(data.aws_route53_zone.hosted_zone.name, ".")
  zone_id                   = data.aws_route53_zone.hosted_zone.zone_id
  subject_alternative_names = var.subject_alternative_names # 
}
