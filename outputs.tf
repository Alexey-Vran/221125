output "vm-external_ip" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "k8s_external_ip" {
  value = yandex_kubernetes_cluster.k8s-cluster.master.0.external_v4_address
}
