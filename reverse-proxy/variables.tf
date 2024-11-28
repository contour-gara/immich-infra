locals {
  appname = "immich"
}

variable "my_global_ip" {
  default = null
}

variable "immich_port" {
  default = null
}

output "my_global_ip" {
  value = var.my_global_ip
}

output "immich_port" {
  value = var.immich_port
}
