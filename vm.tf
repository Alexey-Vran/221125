//Создание виртуальной машины для Lite
resource "yandex_compute_instance" "vm-1" {
  name = var.vm_name
  platform_id = var.vm_platform_id

  resources {
    core_fraction = var.vm_core_fraction
    cores         = var.vm_cores
    memory        = var.vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_operating_system_id
      type     = var.vm_disk_type
      size     = var.vm_disk_size
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
