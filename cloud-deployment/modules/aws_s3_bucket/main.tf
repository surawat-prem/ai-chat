resource "aws_s3_bucket" "main" {
  bucket = var.aws_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    object_ownership = var.aws_s3_bucket_object_ownership
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl = var.aws_s3_bucket_acl

  depends_on = [ aws_s3_bucket_ownership_controls.main ]
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id
  block_public_acls       = var.aws_s3_bucket_block_public_acls
  block_public_policy     = var.aws_s3_bucket_block_public_policy
  ignore_public_acls      = var.aws_s3_bucket_ignore_public_acls
  restrict_public_buckets = var.aws_s3_bucket_restrict_public_buckets
  
  depends_on = [ aws_s3_bucket.main ]
}