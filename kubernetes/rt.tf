resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.default_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "rt_kubernetes" {
  vpc_id = aws_vpc.default_vpc.id

  dynamic "route" {
    for_each = var.cidr_blocks
    content {
      cidr_block = route.value.default
      gateway_id = aws_internet_gateway.gw.id
    }
  }
}

resource "aws_route_table_association" "public_routes" {
  subnet_id      = aws_subnet.public_subnets.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "kubernetes_routes" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.rt_kubernetes.id
}