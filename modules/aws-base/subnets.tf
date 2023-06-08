resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.default_vpc.id
  count                   = length(var.availability_zones)
  cidr_block              = var.cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.default_vpc.id
  count                   = length(var.availability_zones)
  cidr_block              = var.cidr_blocks[count.index + 2]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}