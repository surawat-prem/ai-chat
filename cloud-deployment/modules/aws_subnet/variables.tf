variable "aws_subnets" {
    type = map(object({
      cidr_block = string
      availability_zone = string
      map_public_ip_on_launch = bool
      aws_subnet_tag = map(string)
    }))
}

variable "vpc_id" {
    type = string
}