resource "aws_s3_bucket" "main" {
  bucket = var.aws_bucket_name
  tags = var.aws_bucket_tags
}