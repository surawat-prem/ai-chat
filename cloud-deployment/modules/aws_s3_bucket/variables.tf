variable "aws_bucket_name" {
  type = string
}

variable "aws_s3_bucket_object_ownership" {
  type = string
}

variable "aws_s3_bucket_acl" {
  type = string
}

variable "aws_s3_bucket_block_public_acls" {
  type = bool
}
variable "aws_s3_bucket_block_public_policy" {
  type = bool
}
variable "aws_s3_bucket_ignore_public_acls" {
  type = bool
}
variable "aws_s3_bucket_restrict_public_buckets" {
  type = bool
}