resource "aws_lb" "common_lb" {
  name               = "common-load-balancer"
  load_balancer_type = "application"

  security_groups = [aws_security_group.lb_security_group.id]
  subnets         = [for s in aws_subnet.public : s.id]

  internal                   = false
  enable_deletion_protection = "true"

  tags = local.common_tags
}

resource "aws_security_group" "lb_security_group" {
  name        = "SG_common_load_balancer"
  description = "Security Group controlling ingress and egress for the common load balancer"

  ingress {
    description = "Enforce TLS Ingress Only"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
  }

  tags = local.common_tags
}
