

###############################################################
### Do not create any other resources other than those below ##.
###############################################################

##############################################################################
## Uncomment the resource block below and populate                          ##
## Use values from network_module output and root variables file throughout ##
##############################################################################


#azurerm_application_gateway resource....#
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#


#azurerm_network_interface_application_gateway_backend_address_pool_association#
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association



#resource "azurerm_application_gateway" "network" {}

#resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc" {}

resource "azurerm_application_gateway" "appgtw" {
  name                = "myAppGateway"
  resource_group_name = module.networking.rg_name
  location            = module.networking.rg_location

  sku {
    name     = var.appgw_sku
    tier     = var.appgw_sku
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id =  module.networking.frontend_name
  }

  frontend_port {
    name = var.frontend_port
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = public_ip_address_id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "qalabRoutingRule"
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
    priority                   = 10
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assc" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "nic-VM${count.index + 1}"
  backend_address_pool_id = tolist(azurerm_application_gateway.appgtw.backend_address_pool).0.id
}