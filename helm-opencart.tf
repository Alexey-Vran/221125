//Описание провайдера helm для установки на k8s
provider "helm" {
  kubernetes {
    host                   = yandex_kubernetes_cluster.k8s-cluster.master.0.external_v4_address
    cluster_ca_certificate = yandex_kubernetes_cluster.k8s-cluster.master.0.cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["k8s", "create-token"]
      command     = "yc"
    }
  }
}

//Установка opencart
resource "helm_release" "opencart" {
  name       = "opencart"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "opencart"
  wait       = true

  depends_on = [
    yandex_kubernetes_node_group.nodegroup-1
  ]

  values = [
    file("./values.yaml")
  ]
}
