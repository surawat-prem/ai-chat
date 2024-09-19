provider "aws" {
  region = var.AWS_DEFAULT_REGION
  default_tags {
    tags = {
      Environment = "non-prod"
      Type = "network"
    }
  }
}

module "aws-vpc" {
  source = "../modules/aws_vpc"
  aws_vpcs = var.aws_vpcs
}

module "aws-subnet-workload" {
  source = "../modules/aws_subnet"
  vpc_id = module.aws-vpc.vpc_id["vpc_workload"]
  aws_subnets = var.aws_subnets_workload

  depends_on = [ module.aws-vpc ]
}

module "aws-subnet-controller" {
  source = "../modules/aws_subnet"
  vpc_id = module.aws-vpc.vpc_id["vpc_controller"]
  aws_subnets = var.aws_subnets_controller

  depends_on = [ module.aws-vpc ]
}

module "aws-route-table-subnet-controller" {
  source = "../modules/aws_route_table"
  vpc_id = module.aws-vpc.vpc_id["vpc_controller"]
  # allow internet route
  aws_route_table_cidr_block = "0.0.0.0/0"
  aws_route_table_gw_id = module.aws-vpc.vpc_net_gw_id["vpc_controller"]
  aws_route_table_tags = var.aws_route_table_subnet_controller_tags
  aws_ec2_net_subnet_id = module.aws-subnet-controller.subnet_id["controller-1"]
}

module "aws-vpc-peering" {
  source = "../modules/aws_vpc_peering"
  peer_vpc_id = module.aws-vpc.vpc_id["vpc_controller"]
  vpc_id = module.aws-vpc.vpc_id["vpc_workload"]
  aws_vpc_peer_tags = var.aws_vpc_peer_tags
}

module "aws-kops-user-iam" {
  source = "../modules/aws_kops_iam"
}

module "aws-s3-kops" {
  source = "../modules/aws_s3_bucket"
  aws_bucket_name = var.kops_aws_bucket_name
  aws_bucket_tags = var.kops_aws_bucket_tags
}