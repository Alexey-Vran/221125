terraform {
  required_version = ">= 0.13"
  required_providers {
    yandex   = {
      source = "yandex-cloud/yandex"
    }
  }

//Ключи вынесены в backend.conf. Для инициализации использовать --backend-config=backend.conf
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "bucket-tfstate"
    region                      = "ru-central1"
    key                         = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  service_account_key_file = var.sa_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.availibility_zone_1
}
