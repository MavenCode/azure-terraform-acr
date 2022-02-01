variable "acr_name" { 
}

variable "admin_enabled" {
    description = "Enable admin control. Takes True or False as input"
    default     = "True"
}

variable "sku" {
    description = "SKU (multiple service tier) name of container registry. Possible values: Basic, Standard and Premium"
    default  = "Premium"
}