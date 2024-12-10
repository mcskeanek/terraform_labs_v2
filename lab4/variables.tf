resource "random_password" "password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}

variable "subid" {
  type    = string
  default = "d970f4c1-90d1-4215-b698-3ea4f2e82d83"
}

variable "instances" {
  type    = number
  default = 2
}

variable "appgw_sku" {
  type    = string
  default = "Standard_v2"
}

variable "frontend_port" {
  type    = string
  default = "qalabFrontendPort"
}

variable "frontend_config" {
  type    = string
  default = "qalabAGIPConfig"
}

variable "http_listener_name" {
  type    = string
  default = "qalabListener"
}

variable "backend_address_pool_name" {
  type    = string
  default = "qalabBackendPool"
}

variable "backend_http_settings_name" {
  type    = string
  default = "qalabHTTPsetting"
}