//Создание кластера kubernetes
resource "yandex_kubernetes_cluster" "k8s-cluster" {
  name = var.cluster_name
  network_id = yandex_vpc_network.network.id

  master {
    zonal {
      zone      = yandex_vpc_subnet.subnet-a.zone
      subnet_id = yandex_vpc_subnet.subnet-a.id
    }

    public_ip = true

    security_group_ids = [yandex_vpc_security_group.secgroup.id]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "10:00"
        duration   = "1h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.sa.id
  node_service_account_id = yandex_iam_service_account.sa.id

    depends_on = [
      yandex_resourcemanager_folder_iam_binding.editor,
      yandex_resourcemanager_folder_iam_binding.images-puller
    ]

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}

//Создание нод кластера
resource "yandex_kubernetes_node_group" "nodegroup-1" {
  cluster_id  = yandex_kubernetes_cluster.k8s-cluster.id
  name        = var.node_group_name

  instance_template {
    platform_id = "standard-v3"
    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.subnet-a.id}"]
    }

    resources {
      core_fraction = 20
      memory = 2
      cores  = 2
    }

    boot_disk {
        type = "network-hdd"
        size = 30
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = var.min_nodes
      max     = var.max_nodes
      initial = var.initial_nodes
    }
  }
  
  allocation_policy {
    location {
      zone = var.availibility_zone_1
    }
  }
}
