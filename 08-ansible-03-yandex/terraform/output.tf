output "internal_ip_address_clickhouse" {
  value = "${yandex_compute_instance.clickhouse.network_interface.0.ip_address}"
}

output "external_ip_address_clickhouse" {
  value = "${yandex_compute_instance.clickhouse.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_vector" {
  value = "${yandex_compute_instance.vector.network_interface.0.ip_address}"
}

output "external_ip_address_vector" {
  value = "${yandex_compute_instance.vector.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_lighthouse" {
  value = "${yandex_compute_instance.lighthouse.network_interface.0.ip_address}"
}

output "external_ip_address_lighthouse" {
  value = "${yandex_compute_instance.lighthouse.network_interface.0.nat_ip_address}"
}
