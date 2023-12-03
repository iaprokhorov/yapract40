# using this module requires docker image with psql installed

# resources dependency graph
// [cluster]      [passwords]
//     |             /
//     |            /
//     |           /
//     V          V
//    [owner users]
//         |
//         |
//         V
//     [database]
//         |
//         |
//         V
//  [ro/rw role users]
//         |
//         |
//         V
//     [ro/rw users]


locals {

  reserved_roles = ["mdb_admin", "mdb_monitor", "mdb_replication"]

  owner_user_names = [for db in var.databases : db.owner]
  owner_users      = [for user in var.users : user if contains(local.owner_user_names, user.name)]
  other_users      = [for user in var.users : user if !contains(local.owner_user_names, user.name)]

  role_users = flatten([
    for db in toset(var.databases) : ["role_${db.name}_ro", "role_${db.name}_rw"] if db.auto_create_roles
  ])

  role_users_to_db = merge({
    for db in toset(var.databases) :
    "role_${db.name}_ro" => db.name if db.auto_create_roles
    }, {
    for db in toset(var.databases) :
    "role_${db.name}_rw" => db.name if db.auto_create_roles
  })

  role_users_to_owner = merge({
    for db in toset(var.databases) :
    "role_${db.name}_ro" => db.owner if db.auto_create_roles
    }, {
    for db in toset(var.databases) :
    "role_${db.name}_rw" => db.owner if db.auto_create_roles
  })

  db_owner = {
    for idx, db in toset(var.databases) : db.name => { (db.owner) : true }
  }

  host = "c-${yandex_mdb_postgresql_cluster.cluster.id}.rw.mdb.yandexcloud.net"
}

resource "yandex_mdb_postgresql_cluster" "cluster" {
  name                = var.name
  description         = var.description
  deletion_protection = var.deletion_protection

  environment = var.environment
  network_id  = var.network_id

  security_group_ids = var.security_group_ids


  config {
    backup_retain_period_days = var.backup_retain_period_days
    version                   = var.postgres_version
    resources {
      disk_size          = var.disk_size
      disk_type_id       = var.disk_type_id
      resource_preset_id = var.resource_preset_id
    }

    access {
      data_lens = var.enable_data_lens_access
    }

    performance_diagnostics {
      enabled                      = var.enable_performance_diagnostics
      sessions_sampling_interval   = var.sessions_sampling_interval
      statements_sampling_interval = var.statements_sampling_interval
    }

    pooler_config {
      pooling_mode = var.pooling_mode
    }
  }

  maintenance_window {
    type = var.maintenance_window.type
    day  = var.maintenance_window.day
    hour = var.maintenance_window.hour
  }

  dynamic "host" {
    for_each = var.hosts
    content {
      zone = host.value.zone
      subnet_id = host.value.subnet_id
    }
  }

}

resource "random_password" "user_passwords" {
  for_each = { for idx, user in toset(var.users) : user.name => idx if user.conn_limit != 0 }
  length   = var.database_password_length
  special  = var.database_password_special
  keepers  = try(var.reset_passwords[each.key], null)
}

resource "yandex_mdb_postgresql_database" "dbs" {
  for_each   = { for idx, db in toset(var.databases) : db.name => db }
  cluster_id = yandex_mdb_postgresql_cluster.cluster.id
  name       = each.key
  owner      = yandex_mdb_postgresql_user.owners[each.value.owner].name
  dynamic "extension" {
    for_each = each.value.extensions
    content {
      name = extension.value.name
    }
  }
  lc_collate = each.value.lc_collate
  lc_type    = each.value.lc_type
}


resource "yandex_mdb_postgresql_user" "owners" {
  for_each   = { for idx, user in toset(local.owner_users) : user.name => user }
  cluster_id = yandex_mdb_postgresql_cluster.cluster.id

  name       = each.value.name
  password   = each.value.conn_limit == 0 ? "password" : random_password.user_passwords[each.value.name].result
  login      = each.value.conn_limit == 0 ? false : true
  conn_limit = each.value.conn_limit
  grants     = each.value.grants

  dynamic "permission" {
    # вот эта магия нужна чтобы при создании нового пользователя и базы не было попытке дать юзеру права на еще не созданную базу
    for_each = [for perm in each.value.permissions : perm if !try(local.db_owner[perm.database_name][each.key], false)]
    content {
      database_name = permission.value.database_name
    }
  }

  settings = {
    log_min_duration_statement = var.log_min_duration_statement
  }
}
// owners & users были разделены чтобы избавится от циклических зависимостей
resource "yandex_mdb_postgresql_user" "users" {
  for_each   = { for idx, user in toset(local.other_users) : user.name => user }
  cluster_id = yandex_mdb_postgresql_cluster.cluster.id

  name       = each.value.name
  password   = each.value.conn_limit == 0 ? "password" : random_password.user_passwords[each.value.name].result
  login      = each.value.conn_limit == 0 ? false : true
  conn_limit = each.value.conn_limit
  # итерируем по списку юзеров чтобы создать ссылку на юзера чтобы терраформ построил зависимость между юзерами
  grants = [for grant in each.value.grants : contains(local.reserved_roles, grant) ? grant : try(yandex_mdb_postgresql_user.role_users[grant].name, grant)]

  dynamic "permission" {
    for_each = [
      for perm in distinct(concat(each.value.permissions,
        # на случай если инженер поленился указать permissions, но указал ro/rw роль, мы добавим для этой базы permission сами
        [for grant in each.value.grants : { database_name : local.role_users_to_db[grant] } if try(local.role_users_to_db[grant], null) != null]
      )) :
      # вот эта магия нужна чтобы при создании нового пользователя и базы не было попытке дать юзеру права на еще не созданную базу
      perm if !try(local.db_owner[perm.database_name][each.key], false)
    ]
    content {
      database_name = permission.value.database_name
    }
  }

  settings = {
    log_min_duration_statement = var.log_min_duration_statement
  }
}

resource "yandex_mdb_postgresql_user" "role_users" {
  for_each   = { for user in toset(local.role_users) : user => user }
  cluster_id = yandex_mdb_postgresql_cluster.cluster.id
  name       = each.key
  password   = "password"
  login      = false
  conn_limit = 0

  dynamic "permission" {
    for_each = [yandex_mdb_postgresql_database.dbs[local.role_users_to_db[each.key]].name]
    content {
      database_name = permission.value
    }
  }

  provisioner "local-exec" {
    command     = "${path.module}/role.sh ${local.role_users_to_owner[each.key]} ${each.key} | psql -U ${local.role_users_to_owner[each.key]} -p 6432 -h ${local.host} -d ${local.role_users_to_db[each.key]}"
    interpreter = ["/bin/bash", "-c"]

    environment = {
      PGPASSWORD = random_password.user_passwords[local.role_users_to_owner[each.key]].result
    }
  }
}


resource "null_resource" "regrant" {

  for_each = merge([for db in var.manual_role_granting : { "role_${db}_ro" : "${db}-ro", "role_${db}_rw" : "${db}-rw" }]...)

  provisioner "local-exec" {
    command     = "${path.module}/role.sh ${local.role_users_to_owner[each.key]} ${each.key} | psql -U ${local.role_users_to_owner[each.key]} -p 6432 -h ${local.host} -d ${local.role_users_to_db[each.key]}"
    interpreter = ["/bin/bash", "-c"]

    environment = {
      PGPASSWORD = random_password.user_passwords[local.role_users_to_owner[each.key]].result
    }
  }
}
