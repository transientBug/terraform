data "template_file" "bash_startup" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    name = "${digitalocean_volume.storage.name}"
  }
}

resource "digitalocean_volume" "storage" {
  region      = "nyc1"
  name        = "storage-${var.name}"
  size        = 10
  description = "${var.name} Volume"
}

resource "digitalocean_droplet" "droplet-1" {
  image = "ubuntu-16-04-x64"
  name = "${var.name}-1"

  region = "${var.region}"
  size = "${var.droplet_size}"

  private_networking = true
  ipv6 = true

  monitoring = true

  ssh_keys = "${var.ssh_keys}"

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file(var.shh_connecction_private_key)}"
    timeout = "2m"
  }

  tags = ["${var.tags}"]

  volume_ids = ["${digitalocean_volume.storage.id}"]

  user_data = "${data.template_file.bash_startup.rendered}"
}

resource "digitalocean_floating_ip" "floating-ip-1" {
  droplet_id = "${digitalocean_droplet.droplet-1.id}"
  region     = "${digitalocean_droplet.droplet-1.region}"
}

resource "digitalocean_domain" "staging" {
  name       = "${var.domain_name}"
  ip_address = "${digitalocean_floating_ip.floating-ip-1.ip_address}"
}

resource "digitalocean_record" "staging" {
  domain = "${digitalocean_domain.staging.name}"
  type   = "A"
  name   = "@"
  value  = "${digitalocean_floating_ip.floating-ip-1.ip_address}"
  ttl    = 120
}
