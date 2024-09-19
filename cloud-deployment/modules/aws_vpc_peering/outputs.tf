output "vpc_id" {
    value = { for k, vpc in aws_vpc.main : k => vpc.id }
}

output "vpc_net_gw_id" {
    value = { for k, gateway in aws_internet_gateway.main : k => gateway.id }
}