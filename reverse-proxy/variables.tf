locals {
  appname = "immich"
}

variable "my_global_ip" {
  default = null
}

variable "port" {
  default = null
}

output "my_global_ip" {
  value = var.my_global_ip
}

output "port" {
  value = var.port
}
