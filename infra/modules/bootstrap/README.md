## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.1 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.87.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.87.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_iam_service_account.tf-sa](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account_static_access_key.sa-static-key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_kms_symmetric_key.tf-key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key) | resource |
| [yandex_resourcemanager_folder_iam_binding.sa-editor](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_binding) | resource |
| [yandex_storage_bucket.tf-state](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket) | resource |
| [yandex_ydb_database_iam_binding.admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/ydb_database_iam_binding) | resource |
| [yandex_ydb_database_serverless.tf-state](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/ydb_database_serverless) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Object storage bucket name | `string` | `""` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder ID | `string` | `null` | no |
| <a name="input_sa_name"></a> [sa\_name](#input\_sa\_name) | SA name | `string` | `""` | no |
| <a name="input_ydb_delete_protection"></a> [ydb\_delete\_protection](#input\_ydb\_delete\_protection) | YDB delete protection | `bool` | `true` | no |
| <a name="input_ydb_name"></a> [ydb\_name](#input\_ydb\_name) | YDB name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | SA static key access\_key |
| <a name="output_document_api_endpoint"></a> [document\_api\_endpoint](#output\_document\_api\_endpoint) | YDB database path |
| <a name="output_secret_key"></a> [secret\_key](#output\_secret\_key) | SA static key secret\_key |
