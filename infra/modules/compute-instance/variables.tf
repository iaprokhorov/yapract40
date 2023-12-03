## VM parameters
variable "vm_name" {
  description = "VM name"
  type        = string
}

variable "allow_stopping_for_update" {
  type        = bool
  default     = false
  description = "Changing the resources, platform_id, network_acceleration_type, scheduling_policy, placement_policy, filesystem in an instance requires stopping it. To acknowledge this action, please set allow_stopping_for_update = true"
}

variable "cpu" {
  description = "VM CPU count"
  default     = 2
  type        = number
}

variable "memory" {
  description = "VM RAM size"
  default     = 4
  type        = number
}

variable "core_fraction" {
  description = "Core fraction, default 100%"
  default     = 100
  type        = number
}

variable "disk" {
  description = "VM Disk size"
  default     = 10
  type        = number
}

variable "zone_id" {
  description = "Default zone"
  default     = "ru-central1-a"
  type        = string
}

variable "image_id" {
  description = "Default image ID Ubuntu 20"
  default     = "fd879gb88170to70d38a" # ubuntu-20-04-lts-v20220404
  type        = string
}

variable "subnet_id" {
  type    = string
  default = null
}

# variable "subnet_name" {
#   type    = string
#   default = null
# }

variable "subnets_folder_id" {
  type        = string
  default     = null
  description = "If host subnets are deployed in different folder then set this var."
}

variable "nat" {
  type    = bool
  default = false
}

variable "platform_id" {
  type    = string
  default = "standard-v3"
}

variable "internal_ip_address" {
  type    = string
  default = null
}

variable "nat_ip_address" {
  type    = string
  default = null
}

variable "static_ext_addr" {
  type    = bool
  default = false
}

variable "dns_servers" {
  description = "A space-separated list of IPv4 and IPv6 addresses"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "SG ids list"
  type        = list(any)
  default     = null
}

variable "sg_enable" {
  description = "Enable or disable security group"
  type        = bool
  default     = false
}

variable "disk_type" {
  description = "Disk type"
  type        = string
  default     = "network-ssd"
}

variable "serial" {
  description = "Serial console"
  type        = number
  default     = 0
}

variable "ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "SSH user name"
}

variable "ssh_key" {
  type        = string
  description = "default ssh key"
}

variable "ssh_keys_additional" {
  type        = list(string)
  default     = []
  description = "cloud-config additional ssh keys"
}

# variable "folder_id" {
#   type = string
# }

variable wait_for_ssh {
  type        = bool
  default     = true
  description = "Wait for ansible conects to host before provision"
}

variable provision_common {
  type        = bool
  default     = false
  description = "Do common provision with ansible"
}

variable provision_ntp {
  type        = bool
  default     = false
  description = "Do ntp provision with ansible"
}

variable provision_ssh {
  type        = bool
  default     = false
  description = "Do ssh provision with ansible"
}

variable provision_node_exporter {
  type        = bool
  default     = false
  description = "Do node_exporter provision with ansible"
}
