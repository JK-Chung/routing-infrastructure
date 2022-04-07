resource "aws_ssm_parameter" "public_subnet_ids" {
  count = length(aws_subnet.public)

  name        = format("/vpc/public_subnet/%d", count.index)
  type        = "String"
  value       = aws_subnet.public[count.index].id
  description = "An ID of one of the public subnets"

  tags = local.common_tags
}

resource "aws_ssm_parameter" "elb_security_group" {
  name        = format("/sg/%s", aws_lb.common_lb.name)
  type        = "String"
  value       = aws_security_group.lb_security_group.id
  description = format("The security group protecting the %s", aws_lb.common_lb.name)

  tags = local.common_tags
}

resource "aws_ssm_parameter" "main_vpc_id" {
  name        = "/vpc/main"
  type        = "String"
  value       = aws_vpc.default_vpc.id
  description = "The ID of the main VPC holding infrastructure"

  tags = local.common_tags
}