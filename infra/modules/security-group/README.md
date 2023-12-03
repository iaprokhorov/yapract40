## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.78 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.78 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_security_group.sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the security group | `string` | `null` | no |
| <a name="input_egress"></a> [egress](#input\_egress) | A list of egress rules | <pre>list(object({<br>    protocol          = string                 # One of ANY, TCP, UDP, ICMP, IPV6_ICMP<br>    description       = optional(string)       # Description of the rule<br>    labels            = optional(map(string))  # Labels to assign to this rule<br>    from_port         = optional(number)       # Minimum port number<br>    to_port           = optional(number)       # Maximum port number<br>    port              = optional(number)       # Port number (if applied to a single port)<br>    security_group_id = optional(string)       # Target security group ID for this rule<br>    predefined_target = optional(string)       # Special-purpose targets. self_security_group refers to this particular security group<br>    v4_cidr_blocks    = optional(list(string)) # The blocks of IPv4 addresses for this rule<br>    v6_cidr_blocks    = optional(list(string)) # The blocks of IPv6 addresses for this rule (currently not supported)<br>  }))</pre> | <pre>[<br>  {<br>    "description": "Allow all egress traffic",<br>    "protocol": "ANY",<br>    "v4_cidr_blocks": [<br>      "0.0.0.0/0"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | A list of ingress rules | <pre>list(object({<br>    protocol          = string                 # One of ANY, TCP, UDP, ICMP, IPV6_ICMP<br>    description       = optional(string)       # Description of the rule<br>    labels            = optional(map(string))  # Labels to assign to this rule<br>    from_port         = optional(number)       # Minimum port number<br>    to_port           = optional(number)       # Maximum port number<br>    port              = optional(number)       # Port number (if applied to a single port)<br>    security_group_id = optional(string)       # Target security group ID for this rule<br>    predefined_target = optional(string)       # Special-purpose targets. self_security_group refers to this particular security group<br>    v4_cidr_blocks    = optional(list(string)) # The blocks of IPv4 addresses for this rule<br>    v6_cidr_blocks    = optional(list(string)) # The blocks of IPv6 addresses for this rule (currently not supported)<br>  }))</pre> | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to assign to this security group | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the security group | `string` | `null` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | ID of the network this security group belongs to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | Security Group ID |
