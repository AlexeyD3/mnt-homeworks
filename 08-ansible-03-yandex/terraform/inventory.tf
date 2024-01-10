resource "local_file" "prod" {
  content = <<-DOC
    ---
    clickhouse:
      hosts:
        clickhouse-01:
          ansible_host: ${yandex_compute_instance.clickhouse.network_interface.0.nat_ip_address}
          ansible_user: centos

    vector:
      hosts:
        vector-01:
          ansible_host: ${yandex_compute_instance.vector.network_interface.0.nat_ip_address}
          ansible_user: centos

    lighthouse:
      hosts:
        lighthouse-01:
          ansible_host: ${yandex_compute_instance.lighthouse.network_interface.0.nat_ip_address}
          ansible_user: centos
    DOC
  filename = "../inventory/prod.yaml"

  depends_on = [
    yandex_compute_instance.clickhouse,
    yandex_compute_instance.vector,
    yandex_compute_instance.lighthouse
  ]
}
