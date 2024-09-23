variable "AWS_DEFAULT_REGION" {
    type = string
}

# VPC
variable "aws_vpcs" {
    type = map(object({
      cidr_block = string
      aws_vpc_tag = map(string)
    }))

    default = {
      vpc_workload = {
        "cidr_block" = "10.0.64.0/18"
        "aws_vpc_tag" = {
          Name = "workload"
        }
      },
      vpc_controller = {
        "cidr_block" = "172.16.0.0/22"
        "aws_vpc_tag" = {
          Name = "controller"
        }
      }
    }
}

# VPC PEERING
variable "aws_vpc_peer_tags" {
  default = {
    Name = "vpc-peering-controller-workload"
  }
}

# # ROUTE TABLES

variable "aws_route_table_subnet_controller_tags" {
  default = {
    Name = "subnet-controller-route"
  }
}

# SUBNET WORKLOAD
variable "aws_subnets_workload" {
    type = map(object({
      cidr_block = string
      availability_zone = string
      map_public_ip_on_launch = bool
      aws_subnet_tag = map(string)
    }))

    default = {
      k8s-non-prod-1 = {
        "cidr_block" = "10.0.64.0/20"
        "availability_zone" = "ap-southeast-1a"
        "map_public_ip_on_launch" = false
        "aws_subnet_tag" = {
          Name = "k8s-non-prod-1"
          SubnetType = "Private"
        }
      },
      k8s-non-prod-2 = {
        "cidr_block" = "10.0.80.0/20"
        "availability_zone" = "ap-southeast-1b"
        "map_public_ip_on_launch" = false
        "aws_subnet_tag" = {
          Name = "k8s-non-prod-2"
          SubnetType = "Private"
        }
      },
      k8s-non-prod-3 = {
        "cidr_block" = "10.0.96.0/20"
        "availability_zone" = "ap-southeast-1c"
        "map_public_ip_on_launch" = false
        "aws_subnet_tag" = {
          Name = "k8s-non-prod-3"
          SubnetType = "Private"
        }
      },
      k8s-utility-1 = {
        "cidr_block" = "10.0.120.0/21"
        "availability_zone" = "ap-southeast-1a"
        "map_public_ip_on_launch" = true
        "aws_subnet_tag" = {
          Name = "k8s-utility-1"
          SubnetType = "Utility"
        }
      }
    }
}

# SUBNET CONTROLLER
variable "aws_subnets_controller" {
    type = map(object({
      cidr_block = string
      availability_zone = string
      map_public_ip_on_launch = bool
      aws_subnet_tag = map(string)
    }))

    default = {
      controller-1 = {
        "cidr_block" = "172.16.0.0/24"
        "availability_zone" = "ap-southeast-1a"
        "map_public_ip_on_launch" = false
        "aws_subnet_tag" = {
          Name = "controller-1"
        }
      }
    }
}

# S3
variable "kops_aws_bucket_name_prefix" {
  default = "prem-s3-kops-777"
}
variable "kops_aws_bucket_tags" {
  default = {
    Name = "kops-bucket"
  }
}



variable "kops_aws_bucket_object_ownership" {
  default = "BucketOwnerPreferred"
}
variable "kops_aws_bucket_acl" {
  default = "public-read"
}
variable "kops_aws_bucket_block_public_acls" {
  default = false
}
variable "kops_aws_bucket_block_public_policy" {
  default = false
}
variable "kops_aws_bucket_ignore_public_acls" {
  default = false
}
variable "kops_aws_bucket_restrict_public_buckets" {
  default = false
}