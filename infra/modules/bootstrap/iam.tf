// Create SA
resource "yandex_iam_service_account" "tf-sa" {
  folder_id = var.folder_id
  name      = var.sa_name
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_binding" "s3-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  members   = [
    "serviceAccount:${yandex_iam_service_account.tf-sa.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "ydb-editor" {
  folder_id = var.folder_id
  role      = "ydb.editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.tf-sa.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "kms-tf" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  members   = [
    "serviceAccount:${yandex_iam_service_account.tf-sa.id}",
  ]
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.tf-sa.id
  description        = "static access key for object storage"
}

// Create KMS key
resource "yandex_kms_symmetric_key" "tf-key" {
  name              = "${var.name_prefix}-key"
  description       = "key for encrypt bucket"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}
