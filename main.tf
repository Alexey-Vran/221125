//Создание сервис-аккаунта и назначение ролей
resource "yandex_iam_service_account" "sa" {
  name = var.sa_name
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 folder_id = var.folder_id
 role      = "editor"
 members   = ["serviceAccount:${yandex_iam_service_account.sa.id}"]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 folder_id = var.folder_id
 role      = "container-registry.images.puller"
 members   = ["serviceAccount:${yandex_iam_service_account.sa.id}"]
}

//Создание ключа для шифрования
resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}
