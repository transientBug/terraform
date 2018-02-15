variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "name" {}
variable "domain_name" {}

variable "region" {}
variable "droplet_size" {}
variable "volume_size" {}

variable "ssh_keys" {
  type = "list"
}

variable "tags" {
  type = "list"
}
