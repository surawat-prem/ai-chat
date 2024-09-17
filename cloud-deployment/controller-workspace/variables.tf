# KEY PAIR
variable "aws_key_pair_personal_name" {
  default = "prem-personal-keypair"
}
variable "PERSONAL_PUBLIC_KEY" {
  type = string
  default = ""
}

variable "AWS_DEFAULT_REGION" {
    type = string
}

# EC2 NOBLE CONTROLLER
variable "aws_ec2_controller_instance_type" {
  default = "t3.micro"
}
variable "aws_ec2_controller_tags" {
  default = {
    Name = "controller-vm"
    Environment = "non-prod"
  }
}
variable "aws_ec2_controller_net_tags" {
  default = {
    Name = "controller-vm-network-interface"
    Environment = "non-prod"
  }
}
variable "aws_ec2_controller_net_private_ips" {
  default = ["172.16.0.10"]
}
variable "aws_ec2_controller_sg_tags" {
  default = {
    Name = "controller-vm-security-group"
    Environment = "non-prod"
  }
}
# variable "aws_ec2_controller_ebs_volume_size" {
#   default = 5
# }
# variable "aws_ec2_controller_ebs_volume_tags" {
#   default = {
#     Name = "controller-vm-ebs-volume"
#     Environment = "non-prod"
#   } 
# }
variable "aws_vpc_sg_ingress_rules" {
  type = map(object({
    cidr_ipv4 = string
    from_port = string
    ip_protocol = string
    to_port = string
  }))
  default = {
    ssh = {
      cidr_ipv4 = "49.49.236.98"
      from_port = "22"
      ip_protocol = "tcp"
      to_port = "22"
    }
  }
}

variable "aws_vpc_sg_egress_rules" {
  type = map(object({
    cidr_ipv4 = string
    from_port = string
    ip_protocol = string
    to_port = string
  }))
  default = {
    tcp-internet = {
      cidr_ipv4 = "0.0.0.0"
      from_port = "80-443"
      ip_protocol = "tcp"
      to_port = "80-443"
    }
  }
}