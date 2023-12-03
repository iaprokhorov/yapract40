output "sa_id" {
  description = "SA id"
  value       = yandex_iam_service_account.tf-sa.id
}

output "access_key" {
  description = "SA static key access_key"
  value       = yandex_iam_service_account_static_access_key.sa-static-key.access_key
}

output "secret_key" {
  description = "SA static key secret_key"
  value       = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive   = true
}

output "document_api_endpoint" {
  description = "YDB database path"
  value       = yandex_ydb_database_serverless.tf-state.document_api_endpoint
}
