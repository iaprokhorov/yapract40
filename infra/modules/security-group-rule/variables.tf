###
# required
###
variable "security_group_binding" {
  type        = string
  description = "ID of the security group this rule belongs to"
}

variable "direction" {
  type        = string
  description = "Direction of the rule. Can be ingress (inbound) or egress (outbound)."
}

variable "protocol" {
  type        = string
  description = "One of ANY, TCP, UDP, ICMP, IPV6_ICMP"
}

###
# optional
###
variable "labels" {
  type        = map(string)
  default     = null
  description = "Labels to assign to this security group"
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the rule"
}

variable "from_port" {
  type        = number
  default     = null
  description = "Minimum port number"
}

variable "to_port" {
  type        = number
  default     = null
  description = "Maximum port number"
}

variable "port" {
  type        = number
  default     = null
  description = "Port number (if applied to a single port)"
}

variable "security_group_id" {
  type        = string
  default     = null
  description = "Target security group ID for this rule"
}

variable "predefined_target" {
  type        = string
  default     = null
  description = "Special-purpose targets. self_security_group refers to this particular security group"
}

variable "v4_cidr_blocks" {
  type        = list(string)
  default     = null
  description = "The blocks of IPv4 addresses for this rule"
}

variable "v6_cidr_blocks" {
  type        = list(string)
  default     = null
  description = "The blocks of IPv6 addresses for this rule (currently not supported)"
}
