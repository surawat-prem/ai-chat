resource "aws_subnet" "main" {
    for_each = var.aws_subnets
    vpc_id = var.vpc_id
    cidr_block = each.value["cidr_block"]
    availability_zone = each.value["availability_zone"]
    map_public_ip_on_launch = each.value["map_public_ip_on_launch"]
    tags = each.value["aws_subnet_tag"]
}