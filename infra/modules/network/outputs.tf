output "vpc_id" {
  value = yandex_vpc_network.vpc.id
}

output "subnets" {
  value = { for k, v in var.subnets : v["name"] => yandex_vpc_subnet.subnets[v["name"]].id }
}