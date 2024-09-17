resource "aws_key_pair" "my-personal" {
  key_name = var.aws_key_pair_name
  public_key = var.PERSONAL_PUBLIC_KEY
}