# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1gm5cnlfgcnmeq4an1v"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1ggvhbs15psoc1vgtkc"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-7" {
  default = "fd8nh58q091cqtldf3rr"
}

variable "instance_cores" {
  default = "4"
}

variable "instance_memory" {
  default = "4"
}
