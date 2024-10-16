resource "aws_iam_group" "certmanager" {
  name = "certmanager"
}
resource "aws_iam_user" "certmanager" {
  name = "certmanager"
}
resource "aws_iam_user_group_membership" "certmanager" {
  user = aws_iam_user.certmanager.name
  groups = [
    aws_iam_group.certmanager.id
  ]
}

data "aws_iam_policy_document" "certmanager-policy" {
  statement {
    effect = "Allow"
    actions = [
      "route53:GetChange"
    ]
    resources = ["arn:aws:route53:::change/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZonesByName"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_group_policy" "certmanager" {
  name = "certmanager_group_policy"
  group = aws_iam_group.certmanager.id
  policy = data.aws_iam_policy_document.certmanager-policy.json
}

resource "aws_iam_policy_attachment" "certmanager-user-policy-attachment" {
  name       = "certmanager-user-policy-attachment"
  policy_arn = aws_iam_policy.certmanager-policy.arn
  users      = [aws_iam_user.certmanager-user.name]
}

resource "aws_iam_access_key" "certmanager-user" {
  user = aws_iam_user.certmanager-user.name
}