output "vpc_ids" {
    value = module.aws-vpc.vpc_id
}

# output "vpc_arns" {
#     value = module.aws-vpc.vpc_arn
# }

output "vpc_net_gw_ids" {
    value = module.aws-vpc.vpc_net_gw_id
}

output "subnet_ids_workload" {
    value = module.aws-subnet-workload.subnet_id
}

# output "subnet_arns_workload" {
#     value = module.aws-subnet-workload.subnet_arn
# }

output "subnet_ids_controller" {
    value = module.aws-subnet-controller.subnet_id
}

# output "aws_ec2_noble-controller_id" {
#     value = module.aws-ec2-noble-controller.aws_ec2_id
# }