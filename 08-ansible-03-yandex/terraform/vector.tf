resource "yandex_compute_instance" "vector" {
  name                      = "vector"
  zone                      = "ru-central1-a"
  hostname                  = "vector.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = "${var.instance_cores}"
    memory = "${var.instance_memory}"
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7}"
      name        = "root-vector"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-mnt.id
    nat        = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
