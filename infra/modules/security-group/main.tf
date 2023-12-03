resource "yandex_vpc_security_group" "sg" {
  name        = var.name
  description = var.description
  network_id  = var.network_id

  labels = var.labels

  dynamic "ingress" {
    for_each = var.ingress
    content {
      protocol          = ingress.value.protocol
      description       = ingress.value.description
      labels            = ingress.value.labels
      from_port         = ingress.value.from_port
      to_port           = ingress.value.to_port
      port              = ingress.value.port
      security_group_id = ingress.value.security_group_id
      predefined_target = ingress.value.predefined_target
      v4_cidr_blocks    = ingress.value.v4_cidr_blocks
      v6_cidr_blocks    = ingress.value.v6_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      protocol          = egress.value.protocol
      description       = egress.value.description
      labels            = egress.value.labels
      from_port         = egress.value.from_port
      to_port           = egress.value.to_port
      port              = egress.value.port
      security_group_id = egress.value.security_group_id
      predefined_target = egress.value.predefined_target
      v4_cidr_blocks    = egress.value.v4_cidr_blocks
      v6_cidr_blocks    = egress.value.v6_cidr_blocks
    }
  }
}
