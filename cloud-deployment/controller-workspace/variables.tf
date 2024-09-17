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

# # ROUTE TABLES

# variable "aws_route_table_subnet_controller_tags" {
#   default = {
#     Name = "subnet-controller-route"
#   }
# }

# SUBNET WORKLOAD
variable "aws_subnets_workload" {
    type = map(object({
      cidr_block = string
      availability_zone = string
      aws_subnet_tag = map(string)
    }))

    default = {
      k8s-non-prod-1 = {
        "cidr_block" = "10.0.64.0/20"
        "availability_zone" = "ap-southeast-1a"
        "aws_subnet_tag" = {
          Name = "k8s-non-prod-1"
        }
      },
      dk8s-non-prod-2 = {
        "cidr_block" = "10.0.80.0/20"
        "availability_zone" = "ap-southeast-1b"
        "aws_subnet_tag" = {
          Name = "k8s-non-prod-2"
        }
      }
    }
}

# SUBNET CONTROLLER
variable "aws_subnets_controller" {
    type = map(object({
      cidr_block = string
      availability_zone = string
      aws_subnet_tag = map(string)
    }))

    default = {
      controller-1 = {
        "cidr_block" = "172.16.0.0/24"
        "availability_zone" = "ap-southeast-1a"
        "aws_subnet_tag" = {
          Name = "controller-1"
        }
      }
    }
}

# # KEY PAIR
# variable "aws_key_pair_personal_name" {
#   default = "prem-personal-keypair"
# }
# variable "PERSONAL_PUBLIC_KEY" {
#   type = string
# }

#trigger plan