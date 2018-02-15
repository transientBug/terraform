terraform {
  backend "s3" {
    bucket = "tb-terraform-state"
    key    = "terraform-staging.tfstate"
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

resource "digitalocean_tag" "terraform-managed" {
  name = "terraform-managed"
}

resource "digitalocean_tag" "ansible-managed" {
  name = "ansible-managed"
}

resource "digitalocean_tag" "ssl-terminator" {
  name = "ssl-terminator"
}

resource "digitalocean_tag" "docker-host" {
  name = "docker-host"
}

resource "digitalocean_tag" "staging" {
  name = "staging"
}

module "tb-all-in-one" {
  source = "../modules/tb-all-in-one"

  name = "staging"
  domain_name = "staging.transientbug.ninja"

  region = "nyc1"

  droplet_size = "s-1vcpu-2gb"
  volume_size = 10

  pvt_key = "~/.ssh/id_rsa"

  ssh_keys = [
    "01:d6:1d:60:80:e9:f9:17:22:16:ca:d3:82:17:b3:28",
    "69:aa:78:f6:7e:f6:46:de:f7:c1:fb:6f:60:2f:bf:3b"
  ]

  tags = [
    "${digitalocean_tag.terraform-managed.id}",
    "${digitalocean_tag.ansible-managed.id}",
    "${digitalocean_tag.ssl-terminator.id}",
    "${digitalocean_tag.docker-host.id}",
    "${digitalocean_tag.staging.id}"
  ]
}
