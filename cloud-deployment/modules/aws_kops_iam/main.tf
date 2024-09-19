resource "aws_iam_group" "kops" {
  name = "kops"
}
resource "aws_iam_user" "kops" {
  name = "kops"
}
resource "aws_iam_user_group_membership" "kops" {
  user = aws_iam_user.kops.name
  groups = [
    aws_iam_group.kops.id
  ]
}
resource "aws_iam_access_key" "kops" {
  user = aws_iam_user.kops.name
}
resource "aws_iam_group_policy" "kops" {
  name = "kops_group_policy"
  group = aws_iam_group.kops.id
  policy = data.aws_iam_policy_kops.kops.json
}
data "aws_iam_policy_kops" "kops-policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:*",
      "route53:*",
      "s3:*",
      "iam:*",
      "vpc:*",
      "sqs:*",
      "events:*"
    ]
    resources = ["*"]
  }
  version = "2024-09-19"
}