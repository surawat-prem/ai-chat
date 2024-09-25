variable "aws_vpcs" {
    type = map(object({
      cidr_block = string
      enable_dns_support = bool
      enable_dns_hostnames = bool
      aws_vpc_tag = map(string)
    }))
}