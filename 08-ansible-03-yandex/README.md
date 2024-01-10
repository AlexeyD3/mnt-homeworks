# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

> Подготовил образ через Packer и автоматизировал создание нужных ВМ через терраформ
![screenshot]()

2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
> Переработал старый плейбук и вынес всё в роли.  

2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.

> Динамический инвентори создаётся через терраформ:

```terraform
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

```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
> Плейбук идемпотентен:
![screenshot]()
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
