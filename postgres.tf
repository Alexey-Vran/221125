//Кластер PostgreSQL. В дальнейшем не пригодится (?)
resource "yandex_mdb_postgresql_cluster" "pg-cluster" {
  name                = var.pg_cluster_name
  environment         = var.pg_environment
  network_id          = yandex_vpc_network.network.id
  security_group_ids  = [yandex_vpc_security_group.secgroup.id]
  host_master_name    = var.pg_master_host

  config {
    version = 14
    resources {
      resource_preset_id = var.pg_node_class
      disk_type_id       = var.pg_disk_type
      disk_size          = var.pg_disk_size
    }
  }

  host {
    zone      = var.availibility_zone_1
    subnet_id = yandex_vpc_subnet.subnet-a.id
  }
}

resource "yandex_mdb_postgresql_database" "pg-db" {
  cluster_id = yandex_mdb_postgresql_cluster.pg-cluster.id
  name       = var.pg_db_name
  owner      = var.pg_user_name  
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
  depends_on = [yandex_mdb_postgresql_user.pg-user]
}

resource "yandex_mdb_postgresql_user" "pg-user" {
  cluster_id = yandex_mdb_postgresql_cluster.pg-cluster.id
  name       = var.pg_user_name
  password   = var.pg_user_password
}
