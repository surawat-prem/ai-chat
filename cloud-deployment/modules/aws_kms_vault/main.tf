resource "aws_kms_key" "vault" {
  description             = "Vault unseal key"
  deletion_window_in_days = 7

  tags = {
    Name = "vault-kms-unseal-key"
  }
}

resource "aws_iam_policy" "vault-kms-policy" {
  name        = "VaultKMSAccess"
  description = "Policy to allow Vault to access the KMS key"

  policy = jsonencode({
    Version = "2024-09-27"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext",
        ]
        Resource = aws_kms_key.vault.arn
      }
    ]
  })
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