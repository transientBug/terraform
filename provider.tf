variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

terraform {
  backend "s3" {
    bucket = "tb-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
    endpoint = "https://nyc3.digitaloceanspaces.com"
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_requesting_account_id = true
    skip_metadata_api_check = true
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}
