//Создание виртуальной машины для Lite
resource "yandex_compute_instance" "vm-1" {
  name = "vm-1"
  platform_id = "standard-v3"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.operating_system_id
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }
  
  metadata    = {
    ssh-keys  = "${var.ssh_user}:${file("~/.ssh/id_rsa.pub")}"
  }
}
