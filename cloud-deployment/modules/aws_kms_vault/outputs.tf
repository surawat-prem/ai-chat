output "kms_key_id" {
  value = aws_kms_key.vault.id
}

output "vault_user_access_key_id" {
  value = aws_iam_access_key.vault-user.id
  sensitive = true
}

output "vault_user_secret_key" {
  value = aws_iam_access_key.vault-user.encrypted_secret
  sensitive = true
}