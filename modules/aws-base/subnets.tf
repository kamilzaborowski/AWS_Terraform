resource "aws_subnet" "subnets" {
  vpc_id                  = aws_vpc.default_vpc.id
  count                   = length(var.availability_zones)
  cidr_block              = var.cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}