//Создание списка переменных для целевой группы балансировщика
data "yandex_compute_instance_group" "instancegroup" {
  instance_group_id = yandex_kubernetes_node_group.nodegroup-1.instance_group_id
  depends_on = [
    yandex_kubernetes_node_group.nodegroup-1
  ]
}

locals{
  nodegroup_ip_addresses = data.yandex_compute_instance_group.instancegroup.instances.*.network_interface.0.ip_address
}

//Описание целевой группы нод k8s для балансировщика
resource "yandex_lb_target_group" "lb-targets" {
  name      = "lb-targets"
  region_id = var.region_var

  dynamic "target" {
    for_each = local.nodegroup_ip_addresses
    content {
      subnet_id = "${yandex_vpc_subnet.subnet-a.id}"
      address   = target.value
    }
  }

  depends_on = [
    helm_release.opencart
  ]
}

//Создание балансировщика
resource "yandex_lb_network_load_balancer" "loadbalancer" {
  name = "loadbalancer"

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lb-targets.id

    healthcheck {
      name = "http-health"
        http_options {
          port = 80
          path = "/"
        }
    }
  }

  depends_on = [
    helm_release.opencart
  ]
}
