variable "arm_client_secret" {
    type = string
    description = "azure client secret"
    default="UC_7Q~iHjvbDz6N2KNuCqSbbLMsvokpEFU1Ov"
}

variable "edi_platform_resource_group_name" {
  type        = string
  description = "The name of the resoruce group in Azure that holds the resources for EDI Platform"
  default     = "edi-platform"
}

variable "edi_platform_azure_vault_name" {
  type        = string
  description = "The name of the vault created by the EDI Platform"
  default="edisp-hXwRW7lJ8"
}

variable "edi_platform_azure_automation_account_name" {
  type=string
  description = "The name of the automation account created by the EDI Platform"
  default="edisp-EGsgu9VyZu"
}