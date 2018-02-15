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
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }

  tags = ["${var.tags}"]

  volume_ids = ["${digitalocean_volume.storage.id}"]

  user_data = <<BASH
#!/bin/bash
sudo apt-get update
sudo apt-get -y install python-simplejson python-pip libpq-dev
pip install psycopg2

sudo mkdir -p /mnt/${digitalocean_volume.storage.name}
sudo mount -o discard,defaults /dev/disk/by-id/scsi-0DO_Volume_${digitalocean_volume.storage.name} /mnt/${digitalocean_volume.storage.name}
echo /dev/disk/by-id/scsi-0DO_Volume_${digitalocean_volume.storage.name} /mnt/${digitalocean_volume.storage.name} ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab
BASH
}

resource "digitalocean_floating_ip" "floating-ip-1" {
  droplet_id = "${digitalocean_droplet.droplet-1.id}"
  region     = "${digitalocean_droplet.droplet-1.region}"
}

resource "digitalocean_domain" "staging" {
  name       = "${var.domain_name}"
  ip_address = "${digitalocean_floating_ip.floating-ip-1.ip_address}"
}
