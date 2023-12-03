variable "name" {
  description = "The name of the PostgreSQL cluster."
  type        = string
}

variable "description" {
  description = "The description of the PostgreSQL cluster."
  type        = string
  default     = "Multi-Node PostgreSQL."
}

variable "postgres_version" {
  type        = number
  default     = 14
  description = "PostgreSQL version."
}

variable "databases" {
  description = "List of databases."
  type = list(object({
    name              = string
    owner             = string
    auto_create_roles = optional(bool, false)
    extensions = optional(list(object({
      name = string
    })), [])
    lc_collate = optional(string, "en_US.UTF-8")
    lc_type    = optional(string, "en_US.UTF-8")
  }))
}

variable "users" {
  description = "List of users."
  type = list(object({
    name       = string
    conn_limit = number
    grants     = optional(list(string), [])
    permissions = optional(list(object({
      database_name = string
    })), [])
  }))
}

variable "database_password_length" {
  description = "The database password length."
  type        = number
  default     = 16
}

variable "database_password_special" {
  description = "The database password special."
  type        = bool
  default     = false
}

variable "log_min_duration_statement" {
  description = "Minimum statement duration to log."
  type        = number
  default     = -1
}

variable "disk_size" {
  description = "Volume of the storage available to a PostgreSQL host, in gigabytes."
  type        = number
  default     = 10
}

variable "disk_type_id" {
  description = "Type of the storage of PostgreSQL hosts."
  type        = string
  default     = "network-ssd"
}

variable "resource_preset_id" {
  description = "The ID of the preset for computational resources available to a PostgreSQL host."
  type        = string
  default     = "s3-c2-m8"
}

variable "environment" {
  description = "Deployment environment of the PostgreSQL cluster."
  type        = string
  default     = "PRODUCTION"
}

variable "network_id" {
  description = "The name of the network, to which the PostgreSQL cluster belongs."
  type        = string
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Inhibits deletion of the cluster"
}

variable "maintenance_window" {
  type        = object({
    type = string
    day  = optional(string)
    hour = optional(number)
  })
  default     = {
    type = "WEEKLY"
    day = "SUN"
    hour = 1
  }
  description = "description"
}


variable "hosts" {
  type = list(object({
    zone      = string
    subnet_id = string
  }))
  description = "List of hosts. There should be not less then 3 hosts on using local-ssd disks."
}


variable "backup_retain_period_days" {
  description = "The period in days during which backups are stored. Default is 14 days"
  default     = 14
  type        = number
}

variable "enable_data_lens_access" {
  type        = bool
  description = "Enables access to the cluster from DataLens"
  default     = false
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs"
  default     = []
}

variable "subnets_folder_id" {
  type        = string
  default     = null
  description = "If host subnets are deployed in different folder then set this var."
}

variable "pooling_mode" {
  type        = string
  default     = "SESSION"
  description = "Pooling mode. 'transaction' and 'session' can be used."
}

variable "reset_passwords" {
  type        = map(map(string))
  default     = null
  description = "Keepers to set for random_password object for each username passed"
  # example = {
  #   "username1": {
  #     "reset": "first-reset"
  #   }
  # }
}

variable "manual_role_granting" {
  type        = list(string)
  default     = []
  description = "List of databases to which ro/rw roles should be regranted. Clean this input after using it. Can be used if ro/rw granting exec provisioners fails"

}

variable "enable_performance_diagnostics" {
  type        = bool
  default     = false
  description = "Enables perf diagnostics"
}

variable "statements_sampling_interval" {
  type        = number
  default     = 600
  description = "Interval (in seconds) for pg_stat_statements sampling Acceptable values are 1 to 86400, inclusive."
}

variable "sessions_sampling_interval" {
  type        = number
  description = "Interval (in seconds) for pg_stat_activity sampling Acceptable values are 1 to 86400, inclusive."
  default     = 60
}
