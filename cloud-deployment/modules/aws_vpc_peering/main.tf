resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id = var.peer_vpc_id
  vpc_id = var.vpc_id
  tags = var.aws_vpc_peer_tags
}