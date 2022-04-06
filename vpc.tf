locals {
  # the default VPC has a network mask of 16 bits
  # so when subnet mask has 4 bits, there are 32 - 16 - 4 = 12 bits left for the host ID
  # Each subnet can support (2^12 - 1) hosts/ENIs
  NO_BITS_SUBNET_MASK = 4
}

# Retrieve existing, default VPC
data "aws_vpc" "default_vpc" {
  id = var.default_vpc_id
}

data "aws_availability_zones" "az" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_subnet" "public" {
  count  = 3
  vpc_id = data.aws_vpc.default_vpc.id

  cidr_block = cidrsubnet(
    data.aws_vpc.default_vpc.cidr_block,
    local.NO_BITS_SUBNET_MASK,
    count.index
  )

  availability_zone_id = data.aws_availability_zones.az.zone_ids[count.index]

  tags = merge(local.common_tags, {
    Name = format("Public_Subnet-%d", count.index)
  })
}