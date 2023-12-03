resource "yandex_ydb_database_serverless" "tf-state" {
  name      = var.ydb_name
  folder_id = var.folder_id

  deletion_protection = var.ydb_delete_protection

  depends_on = [
    yandex_iam_service_account.tf-sa
  ]
}