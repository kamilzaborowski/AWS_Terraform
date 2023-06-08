resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default_vpc.id
}