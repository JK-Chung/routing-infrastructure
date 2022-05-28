locals {
  ecs_services_exposed_port = 8080
}

resource "aws_security_group" "lb_security_group" {
  name        = "SG_common_load_balancer"
  description = "Security Group controlling ingress and egress for the common load balancer"
}

resource "aws_security_group_rule" "elb_allow_https_ingress" {
  type              = "ingress"
  description       = "Enforce TLS Ingress Only"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_security_group.id
}

resource "aws_security_group_rule" "elb_allow_http_ingress" {
  type              = "ingress"
  description       = "Allow HTTP (but only for redirects)"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_security_group.id
}

resource "aws_security_group_rule" "elb_allow_egress_to_ecs_services" {
  type              = "egress"
  description       = "Allow Egress Traffic to ECS Services"
  from_port         = local.ecs_services_exposed_port
  to_port           = local.ecs_services_exposed_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_security_group.id
}

resource "aws_security_group" "for_ecs_service_from_elb_traffic_only" {
  name        = "SG_restrict_ecs_service_access_to_elb_only"
  description = "Security Group restricting ECS service network access from the common-load-balancer only"

  ingress {
    description     = "Allow Ingress Traffic from ELB only"
    from_port       = local.ecs_services_exposed_port
    to_port         = local.ecs_services_exposed_port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_security_group.id]
  }

  egress {
    description = "Allow HTTPS Egress Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}