resource "aws_lb" "common_lb" {
  name               = "common-load-balancer"
  load_balancer_type = "application"

  security_groups = [aws_security_group.lb_security_group.id]
  subnets         = [for s in aws_subnet.public : s.id]

  internal                   = false
  enable_deletion_protection = var.environment == "stage" ? "false" : "true"
}

resource "aws_lb_target_group" "applications" {
  for_each = { for a in local.applications : a.fully_qualified_name => a }
  name     = format("%s--%s", each.value.project, each.value.application)
  port     = 8080
  protocol = "HTTP"
  target_type = each.value.target_group_target_type
  vpc_id   = data.aws_vpc.default_vpc.id

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