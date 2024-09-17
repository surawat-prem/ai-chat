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
        "cidr_block" = "10.0.0.0/16"
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
      aws_subnet_tag = map(string)
    }))

    default = {
      k9s-1 = {
        "cidr_block" = "10.0.0.0/20"
        "aws_subnet_tag" = {
          Name = "k9s-1"
        }
      },
      db-1 = {
        "cidr_block" = "10.0.48.0/24"
        "aws_subnet_tag" = {
          Name = "db-1"
        }
      }
    }
}

# SUBNET CONTROLLER
variable "aws_subnets_controller" {
    type = map(object({
      cidr_block = string
      aws_subnet_tag = map(string)
    }))

    default = {
      controller-1 = {
        "cidr_block" = "172.16.0.0/24"
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