location        = "westeurope"
subscription_id = "f04cf23f-e9c2-4475-9d4b-5f2cf992b7cb"

default_tags = {
  application   = "home"
  deployed_by   = "terraform"
}

address_space   = "10.0.0.0/16"
subnet          = "10.0.0.0/24"
network_octets  = "10.0"
#subnets        = {"appnet" = { subnet_octet = "0" }}
vm_size         = "Standard_DS1_v2"