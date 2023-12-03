terraform {
  required_version = ">= 1.4.1"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.87.0"
    }
  }

  # backend "s3" {
  #   endpoint   = "storage.yandexcloud.net"
  #   bucket     = "infra-state"
  #   region     = "ru-central1"
  #   key        = "infra.tfstate"

  #   skip_region_validation      = true
  #   skip_credentials_validation = true
  # }
}
