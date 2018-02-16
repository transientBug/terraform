variable "ssh_connection_private_key" {
  default = "~/.ssh/id_rsa"
}

variable "name" {}
variable "domain_name" {}

variable "region" {
  default = "nyc1"
}

variable "droplet_size" {}
variable "volume_size" {}

variable "ssh_keys" {
  type = "list"
}

variable "tags" {
  type = "list"
}
