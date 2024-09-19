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
  policy = jsondecode({
    "Version": "2024-09-19",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:*",
          "route53:*",
          "s3:*",
          "iam:*",
          "vpc:*",
          "sqs:*",
          "events:*"
        ],
        "Resource": "*"
      }
    ]
  })
}