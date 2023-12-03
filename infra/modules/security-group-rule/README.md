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
| [yandex_vpc_security_group_rule.sg_rule](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the rule | `string` | `null` | no |
| <a name="input_direction"></a> [direction](#input\_direction) | Direction of the rule. Can be ingress (inbound) or egress (outbound). | `string` | n/a | yes |
| <a name="input_from_port"></a> [from\_port](#input\_from\_port) | Minimum port number | `number` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to assign to this security group | `map(string)` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | Port number (if applied to a single port) | `number` | `null` | no |
| <a name="input_predefined_target"></a> [predefined\_target](#input\_predefined\_target) | Special-purpose targets. self\_security\_group refers to this particular security group | `string` | `null` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | One of ANY, TCP, UDP, ICMP, IPV6\_ICMP | `string` | n/a | yes |
| <a name="input_security_group_binding"></a> [security\_group\_binding](#input\_security\_group\_binding) | ID of the security group this rule belongs to | `string` | n/a | yes |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | Target security group ID for this rule | `string` | `null` | no |
| <a name="input_to_port"></a> [to\_port](#input\_to\_port) | Maximum port number | `number` | `null` | no |
| <a name="input_v4_cidr_blocks"></a> [v4\_cidr\_blocks](#input\_v4\_cidr\_blocks) | The blocks of IPv4 addresses for this rule | `list(string)` | `null` | no |
| <a name="input_v6_cidr_blocks"></a> [v6\_cidr\_blocks](#input\_v6\_cidr\_blocks) | The blocks of IPv6 addresses for this rule (currently not supported) | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sg_rule_id"></a> [sg\_rule\_id](#output\_sg\_rule\_id) | Security Group rule ID |
