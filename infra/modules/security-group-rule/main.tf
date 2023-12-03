resource "yandex_vpc_security_group_rule" "sg_rule" {
  security_group_binding = var.security_group_binding
  direction              = var.direction

  labels = var.labels

  protocol          = var.protocol
  description       = var.description
  from_port         = var.from_port
  to_port           = var.to_port
  port              = var.port
  security_group_id = var.security_group_id
  predefined_target = var.predefined_target
  v4_cidr_blocks    = var.v4_cidr_blocks
  v6_cidr_blocks    = var.v6_cidr_blocks
}
