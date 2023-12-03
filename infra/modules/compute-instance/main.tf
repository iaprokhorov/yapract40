locals {
  ip_address = var.nat ? yandex_compute_instance.instance.network_interface[0].nat_ip_address : yandex_compute_instance.instance.network_interface.0.ip_address
}

resource "yandex_vpc_address" "ext_addr" {
  count = var.static_ext_addr ? 1 : 0
  name = "${var.vm_name}-address"

  external_ipv4_address {
    zone_id = var.zone_id
  }
}

resource "yandex_compute_instance" "instance" {
  name        = var.vm_name
  hostname    = var.vm_name
  platform_id = var.platform_id
  zone        = var.zone_id
  
  allow_stopping_for_update = var.allow_stopping_for_update

  resources {
    cores         = var.cpu
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = var.subnet_id
    nat                = var.nat
    ip_address         = var.internal_ip_address
    nat_ip_address     = var.static_ext_addr ? yandex_vpc_address.ext_addr[0].external_ipv4_address[0].address : var.nat_ip_address
    #nat_ip_address     = var.nat_ip_address
    security_group_ids = var.sg_enable ? var.security_group_ids : null
  }

  metadata = {
    ssh-keys           = "${var.ssh_user}:${var.ssh_key}"
    user-data          = templatefile("${path.module}/provision/meta.txt.tpl", { ssh_user = var.ssh_user, ssh_key_default = var.ssh_key, ssh_keys_additional = var.ssh_keys_additional })
    serial-port-enable = var.serial
  }
}
