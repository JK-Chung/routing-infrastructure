resource "aws_lb" "common_lb" {
  name               = "common-load-balancer"
  load_balancer_type = "application"

  security_groups = [aws_security_group.lb_security_group.id]
  subnets         = [for s in aws_subnet.public : s.id]

  internal                   = false
  enable_deletion_protection = true
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.common_lb.arn

  port       = "443"
  protocol   = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08" # recommended by AWS

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "502: Bad Gateway"
      status_code  = "502"
    }
  }
}

module "listener_rules_for_ip_targets" {
  for_each = { for a in local.elb_routable_apps : a.fqdn => a if a.target_group_target_type == "ip" }
  source   = "./alb_listeners_and_target_groups"

  fqdn             = each.key
  project          = each.value.project
  application      = each.value.application
  vpc_id           = data.aws_vpc.default_vpc.id
  alb_listener_arn = aws_lb_listener.listener.arn
}

module "all_projects_tls_certificates" {
  for_each = { for a in local.elb_routable_apps: a.fqdn => a }
  source   = "./tls_for_alb_listeners"

  fqdn            = each.value.fqdn
  route53_zone_id = aws_route53_zone.projects[each.value.env_root_domain].zone_id
  listener_arn    = aws_lb_listener.listener.arn

  # this module is dependent on DNS validation. hence, DNS resources must be set up first
  depends_on = [
    aws_route53_zone.projects,
    module.route53_cross_account
  ]
}