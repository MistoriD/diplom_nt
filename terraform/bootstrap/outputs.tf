output "s3_bucket_name" {
  value       = yandex_storage_bucket.tf_state_bucket.bucket
  description = "Имя созданного S3 бакета для terraform tfstate"
}

output "access_key" {
  value       = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  description = "Access key для доступа к S3 бакету"
  sensitive   = true
}

output "secret_key" {
  value       = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  description = "Secret key для доступа к S3 бакету"
  sensitive   = true
}

output "service_account_id" {
  value       = yandex_iam_service_account.sa_terraform.id
  description = "ID сервисного аккаунта Terraform"
}
