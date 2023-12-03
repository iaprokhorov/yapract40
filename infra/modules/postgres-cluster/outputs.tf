output "host" {
  value       = local.host
  description = "The database host."
}

output "user_passwords" {
  value = {
    for k, v in random_password.user_passwords : k => v.result
  }
  description = "The user passwords."
  sensitive   = true
}

output "cluster_id" {
  value       = yandex_mdb_postgresql_cluster.cluster.id
  description = "The cluster id"
  sensitive   = false
}

output "master_host" {
  value       = local.host
  sensitive   = false
  description = "Current master host fqdn. Should be used for RW connection."
}

output "replica_host" {
  value       = "c-${yandex_mdb_postgresql_cluster.cluster.id}.ro.mdb.yandexcloud.net"
  sensitive   = false
  description = "FQDN for connecting to least delaying replica. Should be used for RO connection."
}

output "roles" {
  value       = merge([for db in var.databases : { (db.name) : { "ro" : "role_${db.name}_ro", "rw" : "role_${db.name}_rw" } }]...)
  description = "Map of database names to roles."
}