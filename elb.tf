resource "aws_lb" "common_lb" {
  name               = "common-load-balancer"
  load_balancer_type = "application"

  security_groups = [aws_security_group.lb_security_group.id]
  subnets         = [for s in aws_subnet.public : s.id]

  internal                   = false
  enable_deletion_protection = true
}

module "listeners_for_ip_targets" {
  for_each = { for a in local.elb_routable_apps : a.fqdn => a if a.target_group_target_type == "ip" }
  source   = "./alb_listeners_and_target_groups"

  fqdn              = each.key
  project           = each.value.project
  application       = each.value.application
  vpc_id            = data.aws_vpc.default_vpc.id
  load_balancer_arn = aws_lb.common_lb.arn
}