###
# required
###
variable "network_id" {
  type        = string
  description = "ID of the network this security group belongs to"
}

###
# optional
###
variable "name" {
  type        = string
  default     = null
  description = "Name of the security group"
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the security group"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to assign to this security group"
}

variable "ingress" {
  type = list(object({
    protocol          = string                 # One of ANY, TCP, UDP, ICMP, IPV6_ICMP
    description       = optional(string)       # Description of the rule
    labels            = optional(map(string))  # Labels to assign to this rule
    from_port         = optional(number)       # Minimum port number
    to_port           = optional(number)       # Maximum port number
    port              = optional(number)       # Port number (if applied to a single port)
    security_group_id = optional(string)       # Target security group ID for this rule
    predefined_target = optional(string)       # Special-purpose targets. self_security_group refers to this particular security group
    v4_cidr_blocks    = optional(list(string)) # The blocks of IPv4 addresses for this rule
    v6_cidr_blocks    = optional(list(string)) # The blocks of IPv6 addresses for this rule (currently not supported)
  }))
  default     = []
  description = "A list of ingress rules"
}

variable "egress" {
  type = list(object({
    protocol          = string                 # One of ANY, TCP, UDP, ICMP, IPV6_ICMP
    description       = optional(string)       # Description of the rule
    labels            = optional(map(string))  # Labels to assign to this rule
    from_port         = optional(number)       # Minimum port number
    to_port           = optional(number)       # Maximum port number
    port              = optional(number)       # Port number (if applied to a single port)
    security_group_id = optional(string)       # Target security group ID for this rule
    predefined_target = optional(string)       # Special-purpose targets. self_security_group refers to this particular security group
    v4_cidr_blocks    = optional(list(string)) # The blocks of IPv4 addresses for this rule
    v6_cidr_blocks    = optional(list(string)) # The blocks of IPv6 addresses for this rule (currently not supported)
  }))
  default = [
    {
      protocol       = "ANY"
      description    = "Allow all egress traffic"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  description = "A list of egress rules"
}
