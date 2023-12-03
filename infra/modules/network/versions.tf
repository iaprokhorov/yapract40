terraform {
  required_version = ">= 1.4.1"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.87.0"
    }
  }
}
