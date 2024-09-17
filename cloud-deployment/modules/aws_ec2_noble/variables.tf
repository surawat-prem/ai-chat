variable "aws_ec2_tags" {
  type = map(string)
}

variable "aws_ec2_net_subnet_id" {
  type = string
}

variable "aws_ec2_net_tags" {
  type = map(string)
}

variable "aws_ec2_net_private_ips" {
  type = list(string)
}

variable "aws_ec2_net_vpc_id" {
  type = string
}

variable "aws_ec2_security_group_tags" {
  type = map(string)
}

variable "aws_ec2_instance_type" {
  type = string
}

variable "aws_ec2_key_name" {
  type = string
}

# variable "aws_ebs_volume_size" {
#   type = number
# }

# variable "aws_ebs_volume_tags" {
#   type = map(string)
# }

variable "aws_vpc_sg_ingress_rules" {
  type = map(object({
    cidr_ipv4 = string
    from_port = number
    ip_protocol = string
    to_port = number
  }))
}

variable "aws_vpc_sg_egress_rules" {
  type = map(object({
    cidr_ipv4 = string
    from_port = number
    ip_protocol = string
    to_port = number
  }))
}