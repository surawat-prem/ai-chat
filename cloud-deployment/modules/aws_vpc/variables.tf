variable "aws_vpcs" {
    type = map(object({
      cidr_block = string
      aws_vpc_tag = map(string)
    }))
}