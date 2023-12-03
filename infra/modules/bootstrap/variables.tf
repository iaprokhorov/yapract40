variable "folder_id" {
  description = "Folder ID"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Prefix name for module resource names"
  type        = string
  default = "bootstrap"
}

variable "bucket_name" {
  description = "Object storage bucket name"
  type        = string
  default = ""
}

variable "sa_name" {
  description = "SA name"
  type        = string
  default = ""
}

variable "ydb_name" {
  description = "YDB name"
  type        = string
  default = ""
}

variable "ydb_delete_protection" {
  description = "YDB delete protection"
  type = bool
  default = true
}

variable "max_size" {
  description = "Bootstrap bucket max size in bytes default 1Gb"
  type        = number
  default = "1073741824"
}
