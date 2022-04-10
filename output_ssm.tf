resource "aws_ssm_parameter" "public_subnet_ids" {
  name        = "/vpc/public_subnets"
  type        = "StringList"
  value       = join(",", [for p in aws_subnet.public : p.id])
  description = "A comma-separated list of the IDs of all public subnets"
}

resource "aws_ssm_parameter" "elb_security_group" {
  name        = format("/sg/%s", aws_lb.common_lb.name)
  type        = "String"
  value       = aws_security_group.lb_security_group.id
  description = format("The security group protecting the %s", aws_lb.common_lb.name)
}

resource "aws_ssm_parameter" "main_vpc_id" {
  name        = "/vpc/main"
  type        = "String"
  value       = data.aws_vpc.default_vpc.id
  description = "The ID of the main VPC holding infrastructure"
}