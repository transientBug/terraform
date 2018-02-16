output "volume-mount" {
  value = "/mnt/${digitalocean_volume.storage.name}"
}

output "floating-ip" {
  value = "${digitalocean_floating_ip.floating-ip-1.ip_address}"
}

output "droplet-ipv4" {
  value = "${digitalocean_droplet.droplet-1.ipv4_address}"
}

output "droplet-ipv6" {
  value = "${digitalocean_droplet.droplet-1.ipv6_address}"
}

output "droplet-private-ipv4" {
  value = "${digitalocean_droplet.droplet-1.ipv4_address_private}"
}

output "droplet-private-ipv6" {
  value = "${digitalocean_droplet.droplet-1.ipv6_address_private}"
}
