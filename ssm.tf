resource "aws_ssm_parameter" "public_subnet_ids" {
  count = length(aws_subnet.public)

  name        = format("/vpc/public_subnet_id/%d", count.index)
  type        = "String"
  value       = aws_subnet.public[count.index].id
  description = "The"

  tags = local.common_tags
}