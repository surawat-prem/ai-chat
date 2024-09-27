resource "aws_kms_key" "vault" {
  description             = "Vault unseal key"
  deletion_window_in_days = 7

  tags = {
    Name = "vault-kms-unseal-key"
  }
}

data "aws_iam_policy_document" "vaukt-policy-data" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext"
    ]
    resources = aws_kms_key.vault.arn
  }
}

resource "aws_iam_policy" "vault-kms-policy" {
  name        = "VaultKMSAccess"
  description = "Policy to allow Vault to access the KMS key"

  policy = data.aws_iam_policy_document.vaukt-policy-data
}

resource "aws_iam_user" "vault-user" {
  name = "vault-kms-user"
}

resource "aws_iam_policy_attachment" "vault-user-policy-attachment" {
  name       = "vault-user-policy-attachment"
  policy_arn = aws_iam_policy.vault-kms-policy.arn
  users      = [aws_iam_user.vault-user.name]
}

resource "aws_iam_access_key" "vault-user" {
  user = aws_iam_user.vault-user.name
}