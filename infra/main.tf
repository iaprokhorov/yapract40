
module "bootstrap" {
  source = "./modules/bootstrap"

  folder_id = var.folder_id

  name_prefix = var.common.name_prefix
  bucket_name  = var.common.bucket_name
  sa_name = var.common.sa_name
  ydb_name = var.common.ydb_name
  ydb_delete_protection = var.common.ydb_delete_protection

}

module "network" {
  source = "./modules/network"

  vpc_name = var.network.vpc_name
  gateway = var.network.gateway
  folder_id = var.folder_id

  subnets = [
    { name = var.network.name_a, cidr = var.network.private_subnet_cidr_a, nat = var.network.nat, zone = var.network.zone_a },
    { name = var.network.name_b, cidr = var.network.private_subnet_cidr_b, nat = var.network.nat, zone = var.network.zone_b },
    { name = var.network.name_c, cidr = var.network.private_subnet_cidr_c, nat = var.network.nat, zone = var.network.zone_c }
  ]
}

data "yandex_vpc_subnet" "prod-ru-central1-a" {
  name      = var.network.name_a
  folder_id = var.folder_id
  depends_on = [module.network]
} 

data "yandex_vpc_subnet" "prod-ru-central1-b" {
  name      = var.network.name_b
  folder_id = var.folder_id
  depends_on = [module.network]
} 

data "yandex_vpc_subnet" "prod-ru-central1-c" {
  name      = var.network.name_c
  folder_id = var.folder_id
  depends_on = [module.network]
}  

module "compute-instance" {
  source = "./modules/compute-instance"
  
  for_each = toset( ["node-01", "node-02"] )
  zone_id = var.instance.zone_id
  
  vm_name  = each.key
  image_id = var.instance.image_id

  cpu           = var.instance.cpu
  memory        = var.instance.memory
  disk          = var.instance.disk

  core_fraction = var.instance.core_fraction

  static_ext_addr = var.instance.static_ext_addr

  # subnet_name = data.yandex_vpc_subnet.prod-ru-central1-b.name
  subnet_id = data.yandex_vpc_subnet.prod-ru-central1-b.subnet_id
  nat       = var.instance.nat

  ssh_key = var.common.ssh_key

  provision_common = var.instance.provision_common
  provision_ssh    = var.instance.provision_ssh
}

# data "yandex_compute_instance" "instance" {
#   name      = "node-01"
#   folder_id = var.folder_id
# #  depends_on = [module.network]
# } 

# resource "yandex_alb_target_group" "alb_target_group" {
#   name           = "lb_group"

#   target {
#     subnet_id    = data.yandex_vpc_subnet.prod-ru-central1-b.subnet_id
#     ip_address   = data.yandex_compute_instance.instance.network_interface.0.ip_address
#   }

#   target {
#     subnet_id    = data.yandex_vpc_subnet.prod-ru-central1-b.subnet_id
#     ip_address   = "data.yandex_compute_instance.instance.network_interface.0.ip_address"
#   }
# }

module "cluster" {
  source = "./modules/postgres-cluster"

  name         = var.pgcluster.cluster_name
  disk_type_id = var.pgcluster.disk_type_id
  disk_size    = var.pgcluster.disk_size


  resource_preset_id = var.pgcluster.resource_preset_id

  network_id = data.yandex_vpc_subnet.prod-ru-central1-b.network_id

  hosts = [
    {
      zone      = var.pgcluster.zone_b
      subnet_id = data.yandex_vpc_subnet.prod-ru-central1-b.subnet_id
    },
  ]

  pooling_mode = var.pgcluster.pooling_mode
  

  databases = [
    {
      name              = var.pgcluster.db_name,
      owner             = var.pgcluster.username_1,
      auto_create_roles = var.pgcluster.auto_create_roles,
      extensions = [
        {
          name = var.pgcluster.ext_name
        }
      ],
      lc_collate = var.pgcluster.lc_collate,
      lc_type    = var.pgcluster.lc_type,
    },
  ]
  users = [
    {
      name        = var.pgcluster.username_1
      conn_limit  = var.pgcluster.conn_limit
      permissions = []
      grants      = [var.pgcluster.user_role_1]
    },
  ]
}

