//Группы безопасности для k8s
resource "yandex_vpc_security_group" "secgroup" {
  name        = "secgroup"
  network_id  = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol          = "ANY"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = [var.cidr_subnet_1, var.cidr_subnet_2]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [var.my_ip]
    from_port      = 22
    to_port        = 22
  }

  dynamic "ingress" {
    for_each = var.in_open_ports
    content {
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = ingress.value
      to_port        = ingress.value
    }
  }

  egress {
    protocol       = "ANY"
    description    = "Правило разрешает весь исходящий трафик"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
