## Requirements

Для создания ролей на локальной машине должен быть установлен бинарник `psql`. Так же с локальной машины должен быть сетевой доступ к кластеру postgresql порт 5432.

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.78 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.78 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.regrant](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.user_passwords](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [yandex_mdb_postgresql_cluster.cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_postgresql_cluster) | resource |
| [yandex_mdb_postgresql_database.dbs](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_postgresql_database) | resource |
| [yandex_mdb_postgresql_user.owners](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_postgresql_user) | resource |
| [yandex_mdb_postgresql_user.role_users](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_postgresql_user) | resource |
| [yandex_mdb_postgresql_user.users](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_postgresql_user) | resource |
| [yandex_vpc_security_group.sec_groups](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/vpc_security_group) | data source |
| [yandex_vpc_subnet.subnets](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/vpc_subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retain_period_days"></a> [backup\_retain\_period\_days](#input\_backup\_retain\_period\_days) | The period in days during which backups are stored. Default is 14 days | `number` | `14` | no |
| <a name="input_database_password_length"></a> [database\_password\_length](#input\_database\_password\_length) | The database password length. | `number` | `16` | no |
| <a name="input_database_password_special"></a> [database\_password\_special](#input\_database\_password\_special) | The database password special. | `bool` | `false` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | List of databases. | <pre>list(object({<br>    name              = string<br>    owner             = string<br>    auto_create_roles = optional(bool, false)<br>    extensions = optional(list(object({<br>      name = string<br>    })), [])<br>    lc_collate = optional(string, "en_US.UTF-8")<br>    lc_type    = optional(string, "en_US.UTF-8")<br>  }))</pre> | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Inhibits deletion of the cluster | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the PostgreSQL cluster. | `string` | `"Multi-Node PostgreSQL."` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Volume of the storage available to a PostgreSQL host, in gigabytes. | `number` | `10` | no |
| <a name="input_disk_type_id"></a> [disk\_type\_id](#input\_disk\_type\_id) | Type of the storage of PostgreSQL hosts. | `string` | `"network-ssd"` | no |
| <a name="input_enable_data_lens_access"></a> [enable\_data\_lens\_access](#input\_enable\_data\_lens\_access) | Enables access to the cluster from DataLens | `bool` | `false` | no |
| <a name="input_enable_performance_diagnostics"></a> [enable\_performance\_diagnostics](#input\_enable\_performance\_diagnostics) | Enables perf diagnostics | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment of the PostgreSQL cluster. | `string` | `"PRODUCTION"` | no |
| <a name="input_hosts"></a> [hosts](#input\_hosts) | List of hosts. There should be not less then 3 hosts on using local-ssd disks. | <pre>list(object({<br>    zone        = string<br>    subnet_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_log_min_duration_statement"></a> [log\_min\_duration\_statement](#input\_log\_min\_duration\_statement) | Minimum statement duration to log. | `number` | `-1` | no |
| <a name="input_manual_role_granting"></a> [manual\_role\_granting](#input\_manual\_role\_granting) | List of databases to which ro/rw roles should be regranted. Clean this input after using it. Can be used if ro/rw granting exec provisioners fails | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the PostgreSQL cluster. | `string` | n/a | yes |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | The name of the network, to which the PostgreSQL cluster belongs. | `string` | n/a | yes |
| <a name="input_pooling_mode"></a> [pooling\_mode](#input\_pooling\_mode) | Pooling mode. 'transaction' and 'session' can be used. | `string` | `"SESSION"` | no |
| <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version) | PostgreSQL version. | `number` | `14` | no |
| <a name="input_reset_passwords"></a> [reset\_passwords](#input\_reset\_passwords) | Keepers to set for random\_password object for each username passed | `map(map(string))` | `null` | no |
| <a name="input_resource_preset_id"></a> [resource\_preset\_id](#input\_resource\_preset\_id) | The ID of the preset for computational resources available to a PostgreSQL host. | `string` | `"s3-c2-m8"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security group names | `list(string)` | `[]` | no |
| <a name="input_sessions_sampling_interval"></a> [sessions\_sampling\_interval](#input\_sessions\_sampling\_interval) | Interval (in seconds) for pg\_stat\_activity sampling Acceptable values are 1 to 86400, inclusive. | `number` | `60` | no |
| <a name="input_statements_sampling_interval"></a> [statements\_sampling\_interval](#input\_statements\_sampling\_interval) | Interval (in seconds) for pg\_stat\_statements sampling Acceptable values are 1 to 86400, inclusive. | `number` | `600` | no |
| <a name="input_subnets_folder_id"></a> [subnets\_folder\_id](#input\_subnets\_folder\_id) | If host subnets are deployed in different folder then set this var. | `string` | `null` | no |
| <a name="input_users"></a> [users](#input\_users) | List of users. | <pre>list(object({<br>    name       = string<br>    conn_limit = number<br>    grants     = optional(list(string), [])<br>    permissions = optional(list(object({<br>      database_name = string<br>    })), [])<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The cluster id |
| <a name="output_host"></a> [host](#output\_host) | The database host. |
| <a name="output_master_host"></a> [master\_host](#output\_master\_host) | Current master host fqdn. Should be used for RW connection. |
| <a name="output_replica_host"></a> [replica\_host](#output\_replica\_host) | FQDN for connecting to least delaying replica. Should be used for RO connection. |
| <a name="output_roles"></a> [roles](#output\_roles) | Map of database names to roles. |
| <a name="output_user_passwords"></a> [user\_passwords](#output\_user\_passwords) | The user passwords. |
