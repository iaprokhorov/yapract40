###
# common
###
variable "common" {
  default = {
    #bootstrap
    name_prefix = "infra"
    bucket_name  = "infra4245-state"
    sa_name = "infra-admin"
    ydb_name = "infra-ydb-tf-state"
    ydb_delete_protection = false
    # ssh
    ssh_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUv/WfFPA2UKKpXqK+P/xB4bK+WcsAQerQ3X8JBG0hP infra-admin"
  }
}

###
# network
###
variable "network" {
  default = {
    vpc_name = "prod-vpc"
    gateway = "true"

    private_subnet_cidr_a     = "10.0.10.0/24"
    private_subnet_cidr_b     = "10.0.20.0/24"
    private_subnet_cidr_c     = "10.0.30.0/24"
    zone_a                    = "ru-central1-a"
    zone_b                    = "ru-central1-b"
    zone_c                    = "ru-central1-c"
    name_a                    = "prod-ru-central1-a"
    name_b                    = "prod-ru-central1-b"
    name_c                    = "prod-ru-central1-c"

    nat = false

  }
  description = "Network settings"
}

###
# instance
###
variable "instance" {
  default = {
    zone_id = "ru-central1-b"
    vm_name  = ["node-01", "node-02"]
    # image
    image_id = "fd8emvfmfoaordspe1jr" # ubuntu-2204-lts
    # resources
    cpu              = 2
    memory           = 4
    disk             = 20
    core_fraction    = 50
    static_ext_addr  = false
    provision_common = true
    provision_ssh    = true

    nat              = true

  }
}

###
# postgres-cluster
###
variable "pgcluster" {
  default = {
    # claster
    cluster_name         = "pg_prod"
    disk_type_id         = "network-ssd"
    disk_size            = 10
    resource_preset_id   = "c3-c2-m4"
    #host
    zone_b               = "ru-central1-b"
    #DB
    pooling_mode         = "SESSION"
    # users
    db_name              = "pg-prod"
    username_1           = "postgresuser"
    auto_create_roles    = false
    
    ext_name = "pg_stat_statements"
    lc_collate = "en_US.UTF-8"
    lc_type    = "en_US.UTF-8"

    conn_limit  = 35

    user_role_1      = "mdb_admin"
  }
  description = "Postgres cluster settings"
}

