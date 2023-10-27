module "edi_platform_secret" {
  source = "github.com/philips-internal/terraform-edi-platform-secrets?ref=v0.1.2"

  region                              = "us-east"
  environment                         = "client-test"
  edisp_azure_vault_name              = var.edi_platform_azure_vault_name
  edisp_resource_group_name           = var.edi_platform_resource_group_name
  edisp_azure_automation_account_name = var.edi_platform_azure_automation_account_name
  variables                           = ["TENANTS", "ORG-ID", "DICOM-STORE-ENDPOINTS"]
}