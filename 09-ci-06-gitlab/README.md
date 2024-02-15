# Домашнее задание к занятию 12 «GitLab»

## Подготовка к выполнению


1. Или подготовьте к работе Managed GitLab от yandex cloud [по инструкции](https://cloud.yandex.ru/docs/managed-gitlab/operations/instance/instance-create) .
Или создайте виртуальную машину из публичного образа [по инструкции](https://cloud.yandex.ru/marketplace/products/yc/gitlab ) .
2. Создайте виртуальную машину и установите на нее gitlab runner, подключите к вашему серверу gitlab  [по инструкции](https://docs.gitlab.com/runner/install/linux-repository.html) .

3. (* Необязательное задание повышенной сложности. )  Если вы уже знакомы с k8s попробуйте выполнить задание, запустив gitlab server и gitlab runner в k8s  [по инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/gitlab-containers). 

4. Создайте свой новый проект.
5. Создайте новый репозиторий в GitLab, наполните его [файлами](./repository).
6. Проект должен быть публичным, остальные настройки по желанию.

## Основная часть

### DevOps

В репозитории содержится код проекта на Python. Проект — RESTful API сервис. Ваша задача — автоматизировать сборку образа с выполнением python-скрипта:

1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated).
2. Python версии не ниже 3.7.
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`.
4. Создана директория `/python_api`.
5. Скрипт из репозитория размещён в /python_api.
6. Точка вызова: запуск скрипта.
7. При комите в любую ветку должен собираться docker image с форматом имени hello:gitlab-$CI_COMMIT_SHORT_SHA . Образ должен быть выложен в Gitlab registry или yandex registry.   
<br/><br/>
![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-06-gitlab/09-ci-06-gitlab/img/job1.png?raw=true)
<br/><br/>
### Product Owner

Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить.
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`.
3. Issue поставить label: feature.
<br/><br/>
![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-06-gitlab/09-ci-06-gitlab/img/issue.png?raw=true)
<br/><br/>
### Developer

Пришёл новый Issue на доработку, вам нужно:

1. Создать отдельную ветку, связанную с этим Issue.
2. Внести изменения по тексту из задания.
3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно.
<br/><br/>
![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-06-gitlab/09-ci-06-gitlab/img/job2.png?raw=true)
<br/><br/>
### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность.
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.
```bash
alex@ubuntu22:~$ docker run -p 5290:5290 -d --name hello comita.gitlab.yandexcloud.net:5050/alexeyd3/devops-netology/hello:gitlab-d82c87d5
Unable to find image 'comita.gitlab.yandexcloud.net:5050/alexeyd3/devops-netology/hello:gitlab-d82c87d5' locally
gitlab-d82c87d5: Pulling from alexeyd3/devops-netology/hello


alex@ubuntu22:~$ docker ps
CONTAINER ID   IMAGE                                                                               COMMAND                  CREATED          STATUS          PORTS                                       NAMES
1c1c966a1427   comita.gitlab.yandexcloud.net:5050/alexeyd3/devops-netology/hello:gitlab-d82c87d5   "python3.8 /python_a…"   14 seconds ago   Up 13 seconds   0.0.0.0:5290->5290/tcp, :::5290->5290/tcp   hello

alex@ubuntu22:~$ curl localhost:5290/rest/api/get_info
{"version": 3, "method": "GET", "message": "Running"}
```
![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-06-gitlab/09-ci-06-gitlab/img/merge1.png?raw=true)

## Итог

В качестве ответа пришлите подробные скриншоты по каждому пункту задания:

- файл gitlab-ci.yml;
```yaml
stages:
  - build
  - deploy
image: docker:stable
services:
  - name: docker:dind
    alias: thedockerhost
variables:
  DOCKER_HOST: tcp://thedockerhost:2375/
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""
build-job:
  stage: build
  script:
    - docker build -t some_local_build:latest .
  except:
    - main
deploy-job:
  stage: deploy
  script:
    - docker build -t $CI_REGISTRY/alexeyd3/devops-netology/hello:gitlab-$CI_COMMIT_SHORT_SHA .
    - echo "$CI_REGISTRY_PASSWORD" | docker login $CI_REGISTRY --username $CI_REGISTRY_USER --password-stdin
    - docker push $CI_REGISTRY/alexeyd3/devops-netology/hello:gitlab-$CI_COMMIT_SHORT_SHA
  only:
    - main
```

- Dockerfile; 
```Dockerfile
FROM centos:8
#fix centos stream repo
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
#install python from source code
ENV VERSION=3.8.18
RUN yum -y install epel-release
RUN yum update -y
RUN yum -y groupinstall "Development Tools"
RUN yum -y install openssl-devel bzip2-devel libffi-devel xz-devel
RUN yum -y install wget
RUN wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz
RUN tar xf Python-$VERSION.tgz
RUN rm Python-$VERSION.tgz
CMD Python-$VERSION/
RUN chmod +x /Python-$VERSION/configure
RUN /Python-$VERSION/configure --enable-optimizations
RUN make altinstall
RUN python3.8 --version
RUN pip3.8 --version
#copy app and requirements
COPY requirements.txt .
RUN pip3.8 install --no-cache-dir -r requirements.txt
COPY app.py /python_api/app.py
WORKDIR /python_api
CMD ["python3.8", "/python_api/app.py"]
```
- лог успешного выполнения пайплайна;
- решённый Issue.

### Важно 
После выполнения задания выключите и удалите все задействованные ресурсы в Yandex Cloud.

