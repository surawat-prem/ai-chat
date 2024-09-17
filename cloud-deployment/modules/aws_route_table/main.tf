resource "aws_route_table" "main" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.aws_route_table_cidr_block
    gateway_id = var.aws_route_table_gw_id
  }
  tags = var.aws_route_table_tags
}

resource "aws_route_table_association" "main" {
  subnet_id = var.aws_ec2_net_subnet_id
  route_table_id = aws_route_table.main.id
}