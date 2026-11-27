terraform {
  required_version = ">= 1.5.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.120"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}

# 1. Сервисный аккаунт для управления инфраструктурой и бекендом
resource "yandex_iam_service_account" "sa_terraform" {
  name        = "sa-terraform-diplom"
  description = "Сервисный аккаунт для Terraform инфраструктуры"
}

# 2. Назначение ролей сервисному аккаунту
# editor - для управления ресурсами в каталоге
resource "yandex_resourcemanager_folder_iam_member" "sa_editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa_terraform.id}"
}

# storage.admin - для полного управления Object Storage (бакетом состояния)
resource "yandex_resourcemanager_folder_iam_member" "sa_storage_admin" {
  folder_id = var.yc_folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa_terraform.id}"
}

# 3. Статический ключ доступа для S3 (Object Storage)
resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.sa_terraform.id
  description        = "Статический ключ для S3 bucket tfstate"
}

# 4. S3 Бакет для хранения terraform.tfstate
# Имя бакета должно быть глобально уникальным, поэтому добавим суффикс
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "yandex_storage_bucket" "tf_state_bucket" {
  bucket     = "tf-state-diplom-${random_string.bucket_suffix.result}"
  access_key = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_static_key.secret_key

  # Защита от случайного удаления
  force_destroy = true

  depends_on = [
    yandex_resourcemanager_folder_iam_member.sa_storage_admin
  ]
}
