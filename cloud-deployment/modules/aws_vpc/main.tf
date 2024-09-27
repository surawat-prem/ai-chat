resource "aws_vpc" "main" {
    for_each = var.aws_vpcs
    cidr_block = each.value["cidr_block"]
    enable_dns_support = each.value["enable_dns_suuport"]
    enable_dns_hostnames =each.value["enable_dns_hostnames"]
    instance_tenancy = "default"
    tags = each.value["aws_vpc_tag"]
}

resource "aws_internet_gateway" "main" {
  for_each = var.aws_vpcs
  vpc_id = aws_vpc.main[each.key].id
  tags = each.value["aws_vpc_tag"]
}