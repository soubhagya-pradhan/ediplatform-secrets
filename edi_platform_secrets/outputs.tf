output "iam_tenant_orgs" {
    value = jsondecode(module.edi_platform_secret.variables["TENANTS"])
}

output "dss_store_end_points" {
    value = jsondecode(module.edi_platform_secret.variables["DICOM-STORE-ENDPOINTS"])
}

output "service_id" {
    value = module.edi_platform_secret.secrets["SERVICE-ID"]
}

output "service_private_key" {
    value = module.edi_platform_secret.secrets["SERVICE-KEY"]
}

output "edi_logging_product_key" {
    value = module.edi_platform_secret.secrets["EDIPLATFORM-LOGGING-PRODUCT-KEY"]
}

output "edi_logging_log_drainer_uri" {
    value = module.edi_platform_secret.secrets["DIPLATFORM-LOGGING-LOGDRAINER-URI"]
}