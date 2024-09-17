variable "aws_subnets" {
    type = map(object({
      cidr_block = string
      aws_subnet_tag = map(string)
    }))
}

variable "vpc_id" {
    type = string
}