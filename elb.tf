resource "aws_lb" "common_lb" {
  name               = "common-load-balancer"
  load_balancer_type = "application"

  security_groups = [aws_security_group.lb_security_group.id]
  subnets         = [for s in aws_subnet.public : s.id]

  internal                   = false
  enable_deletion_protection = true
}

resource "aws_lb_target_group" "elb_routable_apps" {
  for_each    = { for a in local.elb_routable_apps : a.fqdn => a }
  name        = format("%s--%s", each.value.project, each.value.application)
  port        = 8080
  protocol    = "HTTP"
  target_type = each.value.target_group_target_type
  vpc_id      = data.aws_vpc.default_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5

    path     = "/health"
    matcher  = "200"
    protocol = "HTTP"
    port     = "traffic-port"

  }
}

resource "aws_lb_listener" "elb_routable_apps" {
  for_each          = { for a in local.elb_routable_apps : a.fqdn => a }
  load_balancer_arn = aws_lb.common_lb.arn
  
  port              = "80"
  protocol          = "HTTP"
  # TODO use HTTPS ssl_policy        = "ELBSecurityPolicy-2016-08" # recommended by AWS

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "502: Bad Gateway"
      status_code  = "502"
    }
  }
}

resource "aws_lb_listener_rule" "elb_routable_apps" {
  for_each     = { for a in local.elb_routable_apps : a.fqdn => a }
  listener_arn = aws_lb_listener.elb_routable_apps[each.key].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb_routable_apps[each.key].arn
  }

  condition {
    host_header {
      values = [each.key]
    }
  }
}