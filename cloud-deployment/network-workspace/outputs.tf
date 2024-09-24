output "vpc_ids" {
    value = module.aws-vpc.vpc_id
}

output "vpc_net_gw_ids" {
    value = module.aws-vpc.vpc_net_gw_id
}

# output "subnet_ids_workload" {
#     value = module.aws-subnet-workload.subnet_id
# }

output "subnet_ids_controller" {
    value = module.aws-subnet-controller.subnet_id
}

output "kops_bucket_domain_name" {
  value = module.aws-s3-kops.bucket_domain_name
}