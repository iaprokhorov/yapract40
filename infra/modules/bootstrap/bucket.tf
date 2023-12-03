resource "yandex_storage_bucket" "tf-state" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = var.bucket_name
  max_size = var.max_size

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "${var.name_prefix}-policy",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {"CanonicalUser": "${yandex_iam_service_account.tf-sa.id}"},
        "Action": "*",
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}/*",
          "arn:aws:s3:::${var.bucket_name}"
        ],
        "Sid": "${var.name_prefix}-rules"
      },
      {
        "Condition": {
           "StringLike": {
              "aws:referer": [
                  "https://console.cloud.yandex.ru/folders/*/storage/buckets/${var.bucket_name}*",
                  "https://console.cloud.yandex.com/folders/*/storage/buckets/${var.bucket_name}*"
                ]
            }
        },
        "Effect": "Allow",
        "Principal": "*",
        "Action": "*",
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}/*",
          "arn:aws:s3:::${var.bucket_name}"
        ],
        "Sid": "console-statement"
      }
    ]
  }
  POLICY

  versioning {
    enabled = true
  }

  grant {
    type        = "CanonicalUser"
    id          = yandex_iam_service_account.tf-sa.id
    permissions = ["FULL_CONTROL"] 
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.tf-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

}
