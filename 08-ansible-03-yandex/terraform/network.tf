# Network
resource "yandex_vpc_network" "network-mnt" {
  name = "network-mnt"
}

resource "yandex_vpc_subnet" "subnet-mnt" {
  name           = "subnet-mnt"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-mnt.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
