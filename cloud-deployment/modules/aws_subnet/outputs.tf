output "subnet_id" {
    value = { for k, subnet in aws_subnet.main : k => subnet.id }
}

# output "subnet_arn" {
#     value = { for k, subnet in aws_subnet.main : k => subnet.arn }
# }