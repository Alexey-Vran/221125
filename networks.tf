//Создание сетевых ресурсов
resource "yandex_vpc_network" "network" {
  name = "network"
}

//Создание подсети
resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  zone           = var.availibility_zone_1
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [var.cidr_subnet_1]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "subnet-b"
  zone           = var.availibility_zone_2
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [var.cidr_subnet_2]
}
