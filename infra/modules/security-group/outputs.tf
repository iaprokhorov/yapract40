output "sg_id" {
  value       = yandex_vpc_security_group.sg.id
  sensitive   = false
  description = "Security Group ID"
}
