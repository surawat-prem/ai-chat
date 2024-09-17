variable "vpc_id" {
    type = string
}

variable "aws_route_table_cidr_block" {
  type = string
}

variable "aws_route_table_gw_id" {
  type = string
}

variable "aws_ec2_net_subnet_id" {
  type = string
}

variable "aws_route_table_tags" {
  type = map(string)
}