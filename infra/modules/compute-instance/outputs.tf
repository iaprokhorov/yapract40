output "internal_ip" {
  value = yandex_compute_instance.instance.network_interface.0.ip_address
}

output "nat_ip" {
  value = yandex_compute_instance.instance.network_interface.0.nat_ip_address
}

#output "static_ip" {
#  value = yandex_vpc_address.ext_addr[0].external_ipv4_address[0].address
#}

output "ip_address" {
  value = local.ip_address
}

output "hostname" {
  value = yandex_compute_instance.instance.hostname
}
