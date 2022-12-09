//Общие
variable "sa_key_file" {}
variable "cloud_id" {}
variable "folder_id" {}
variable "sa_name" {}
variable "ssh_user" {}

//Для сетей
variable "cidr_subnet_1" {}
variable "cidr_subnet_2" {}
variable "availibility_zone_1" {}
variable "availibility_zone_2" {}
variable "region_var" {}
variable "my_ip" {}

//Для виртуальных машин
variable "operating_system_id" {}

//Для бакета
variable "bucket_name" {}
variable "bucket_sa_permissions" {}

//Для k8s
variable "cluster_name" {}
variable "node_group_name" {}
variable "min_nodes" {}
variable "max_nodes" {}
variable "initial_nodes" {}

//Для PostgreSQL
variable "pg_cluster_name" {}
variable "pg_environment" {}
variable "pg_master_host" {}
variable "pg_node_class" {}
variable "pg_disk_type" {}
variable "pg_disk_size" {}
variable "pg_db_name" {}
variable "pg_user_name" {}
variable "pg_user_password" {}
