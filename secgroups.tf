//Группы безопасности для k8s
resource "yandex_vpc_security_group" "secgroup" {
  name        = "secgroup"
  description = "Правила группы обеспечивают базовую работоспособность кластера. Примените ее к кластеру и группам узлов"
  network_id  = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    description    = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера и сервисов"
    v4_cidr_blocks = [var.cidr_subnet_1, var.cidr_subnet_2]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "ICMP"
    description    = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
  
  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключения к веб-серверам по http"
    port           = 80
    v4_cidr_blocks = [var.my_ip]
  }
  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключения к веб-серверам по https"
    port           = 443
    v4_cidr_blocks = [var.my_ip]
  }

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к узлам по SSH с указанных IP-адресов."
    v4_cidr_blocks = [var.my_ip]
    port           = 22
  }

ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к узлам для helm с указанных IP-адресов."
    v4_cidr_blocks = [var.my_ip]
    port           = 9443
  }

  egress {
    protocol       = "ANY"
    description    = "Правило разрешает весь исходящий трафик"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
