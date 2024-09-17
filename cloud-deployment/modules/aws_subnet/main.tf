resource "aws_subnet" "main" {
    for_each = var.aws_subnets
    vpc_id = var.vpc_id
    cidr_block = each.value["cidr_block"]
    tags = each.value["aws_subnet_tag"]
}