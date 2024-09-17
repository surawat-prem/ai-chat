variable "aws_subnets" {
    type = map(object({
      cidr_block = string
      availability_zone = string
      aws_subnet_tag = map(string)
    }))
}

variable "vpc_id" {
    type = string
}