#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NORMAL='tput sgr0'

echo -en "\n $GREEN Остановка и удаление старых docker-контейнеров: $BLUE \n"


docker stop ubuntu centos7 fedora && docker rm ubuntu centos7 fedora 1> /dev/null
$NORMAL

echo -en "\n $GREEN Контейнеры удалены $BLUE \n"
$NORMAL

echo -en "\n $GREEN Запуск docker-контейнеров: \n"
$NORMAL

docker-compose up -d

echo -en "\n $GREEN Контейнеры запущены \n"
$NORMAL

echo -en "\n $GREEN Запуск ansible-playbook \n"
$NORMAL

echo -en "\n $BLUE Введите пароль для ansible-vault \n"
$NORMAL

ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass

echo -en "\n $GREEN Остановка docker-контейнеров: $BLUE \n"

docker stop ubuntu centos7 fedora
$NORMAL

echo -en "\n $GREEN Контейнеры остановлены \n\n"
$NORMAL

exit 0