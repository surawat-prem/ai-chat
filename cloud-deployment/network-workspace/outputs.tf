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


# Vault KMS
output "kms_key_id" {
  value = module.aws-vault-kms.kms_key_id
}

output "vault_user_access_key" {
  value = module.aws-vault-kms.vault_user_access_key
  sensitive = true
}

output "vault_user_secret_key" {
  value = module.aws-vault-kms.vault_user_secret_key
  sensitive = true
}