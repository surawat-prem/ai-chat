output "certmanager_user_access_key_id" {
  value = aws_iam_access_key.certmanager-user.id
  sensitive = true
}

output "certmanager_user_secret_key" {
  value = aws_iam_access_key.certmanager-user.encrypted_secret
  sensitive = true
}