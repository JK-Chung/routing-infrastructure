resource "aws_lb" "common_lb" {
  name               = "common-load-balancer"
  load_balancer_type = "application"

  security_groups = [aws_security_group.lb_security_group.id]
  subnets         = [for s in aws_subnet.public : s.id]

  internal                   = false
  enable_deletion_protection = var.environment == "stage" ? "false" : "true"
}

resource "aws_lb_target_group" "applications" {
  for_each    = { for a in local.routable_applications : a.domain_name => a }
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

resource "aws_lb_listener" "applications" {
  for_each          = { for a in local.routable_applications : a.domain_name => a }
  load_balancer_arn = aws_lb.common_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # recommended by AWS

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Bad Gateway"
      status_code  = "502"
    }
  }
}

resource "aws_lb_listener_rule" "applications" {
  for_each     = { for a in local.routable_applications : a.domain_name => a }
  listener_arn = aws_lb_listener.applications[each.key].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.applications[each.key].arn
  }

  condition {
    host_header {
      values = [each.key]
    }
  }
}