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

resource "digitalocean_volume" "staging-storage" {
  region      = "nyc1"
  name        = "staging-storage"
  size        = 10
  description = "Staging Volume"
}

resource "digitalocean_droplet" "staging-1" {
  image = "ubuntu-16-04-x64"
  name = "staging-1"

  region = "nyc1"
  size = "1gb"

  private_networking = true
  ipv6 = true

  monitoring = true

  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }

  tags = [
    "${digitalocean_tag.terraform-managed.id}",
    "${digitalocean_tag.ansible-managed.id}",
    "${digitalocean_tag.ssl-terminator.id}",
    "${digitalocean_tag.docker-host.id}"
  ]

  volume_ids = ["${digitalocean_volume.staging-storage.id}"]

  user_data = <<BASH
#!/bin/bash
sudo apt-get update
sudo apt-get -y install python-simplejson python-pip libpq-dev
pip install psycopg2

sudo mkdir -p /mnt/${digitalocean_volume.staging-storage.name}
sudo mount -o discard,defaults /dev/disk/by-id/scsi-0DO_Volume_${digitalocean_volume.staging-storage.name} /mnt/${digitalocean_volume.staging-storage.name}
echo /dev/disk/by-id/scsi-0DO_Volume_${digitalocean_volume.staging-storage.name} /mnt/${digitalocean_volume.staging-storage.name} ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab
BASH
}

resource "digitalocean_floating_ip" "staging-1" {
  droplet_id = "${digitalocean_droplet.staging-1.id}"
  region     = "${digitalocean_droplet.staging-1.region}"
}

resource "digitalocean_domain" "staging" {
  name       = "staging.transientbug.ninja"
  ip_address = "${digitalocean_floating_ip.staging-1.ip_address}"
}
