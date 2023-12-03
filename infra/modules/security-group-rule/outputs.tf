output "sg_rule_id" {
  value       = yandex_vpc_security_group_rule.sg_rule.id
  sensitive   = false
  description = "Security Group rule ID"
}
