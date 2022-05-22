resource "aws_lb_target_group" "target_group" {
  name        = format("%s--%s", var.project, var.application)
  port        = 8080
  protocol    = "HTTP"
  target_type = var.target_group_target_type
  vpc_id      = var.vpc_id

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

# One listener will be used for all FQDNs (not PER FQDN as it is currently)
# TODO extract this resource out of this module (and change priority on listener rule)
resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.load_balancer_arn

  port     = "80"
  protocol = "HTTP"
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

resource "aws_lb_listener_rule" "listener_forward_rule" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = [var.fqdn]
    }
  }
}

resource "aws_ssm_parameter" "target_group" {
  name        = format("/elb/target-groups/%s/%s", var.project, var.application)
  type        = "String"
  value       = aws_lb_target_group.target_group.arn
  description = format("A target-group created for the application: %s--%s", var.project, var.application)
}