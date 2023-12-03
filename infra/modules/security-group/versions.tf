terraform {
  required_version = ">= 1.0.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.78"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}
