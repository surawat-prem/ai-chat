provider "aws" {
  region = var.AWS_DEFAULT_REGION
  default_tags {
    tags = {
      Environment = "non-prod"
      Type = "workload"
    }
  }
}

data "terraform_remote_state" "network" {
  backend = "remote"
  config = {
    organization = "chat-system-infra"
    workspaces = {
      name = "network"
    }
  }
}


module "aws-key-pair-personal" {
  source = "../modules/aws_key_pair"
  aws_key_pair_name = var.aws_key_pair_personal_name
  PERSONAL_PUBLIC_KEY = var.PERSONAL_PUBLIC_KEY
}

module "aws-ec2-noble-controller" {
  source = "../modules/aws_ec2_noble"
  aws_ec2_instance_type = var.aws_ec2_controller_instance_type
  aws_ec2_key_name = var.aws_key_pair_personal_name
  aws_ec2_tags = var.aws_ec2_controller_tags

  aws_ec2_net_subnet_id = data.terraform_remote_state.network.outputs.subnet_ids_workload["controller-1"]
  aws_ec2_net_private_ips = var.aws_ec2_controller_net_private_ips
  aws_ec2_net_tags = var.aws_ec2_controller_net_tags
  aws_ec2_net_vpc_id = data.terraform_remote_state.network.outputs.vpc_ids["vpc_controller"]

  aws_ec2_security_group_tags = var.aws_ec2_controller_sg_tags
  aws_vpc_sg_ingress_rules = var.aws_vpc_sg_ingress_rules
  aws_vpc_sg_egress_rules = var.aws_vpc_sg_egress_rules

  # aws_ebs_volume_size = var.aws_ec2_controller_ebs_volume_size
  # aws_ebs_volume_tags = var.aws_ec2_controller_ebs_volume_tags

}