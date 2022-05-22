resource "aws_security_group" "lb_security_group" {
  name        = "SG_common_load_balancer"
  description = "Security Group controlling ingress and egress for the common load balancer"

  ingress {
    description = "Enforce TLS Ingress Only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP (but only for redirects)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}