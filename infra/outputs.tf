output "sa_access_key" {
  description = "SA static key access_key"
  value       = module.bootstrap.access_key
}

output "sa_secret_key" {
  description = "SA static key secret_key"
  value       = module.bootstrap.secret_key
  sensitive = true
}

output "ydb_document_api_endpoint" {
  description = "YDB database path"
  value = module.bootstrap.document_api_endpoint
}

output "pg_host" {
  value = module.cluster.master_host
}

output "pg_user_passwords" {
  value     = module.cluster.user_passwords
  sensitive = true
}