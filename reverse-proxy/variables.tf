locals {
  appname = "immich"
}

variable "my_global_ip" {
  default = null
}

output "my_global_ip" {
  value = var.my_global_ip
}
