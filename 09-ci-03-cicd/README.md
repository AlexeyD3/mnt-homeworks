# Домашнее задание к занятию 9 «Процессы CI/CD»

## Подготовка к выполнению

1. Создайте два VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).

![screenshot]()

2. Пропишите в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook](./infrastructure/site.yml) созданные хосты.
3. Добавьте в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе — найдите таску в плейбуке, которая использует id_rsa.pub имя, и исправьте на своё.
4. Запустите playbook, ожидайте успешного завершения.

![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-03-cidi/09-ci-03-cicd/img/Screenshot%20from%202024-02-15%2022-49-07.png?raw=true)

5. Проверьте готовность SonarQube через [браузер](http://localhost:9000).
6. Зайдите под admin\admin, поменяйте пароль на свой.

![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-03-cidi/09-ci-03-cicd/img/Screenshot%20from%202024-02-15%2022-53-28.png?raw=true)

7.  Проверьте готовность Nexus через [бразуер](http://localhost:8081).
8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-03-cidi/09-ci-03-cicd/img/Screenshot%20from%202024-02-15%2022-58-43.png?raw=true)

## Знакомоство с SonarQube

### Основная часть

1. Создайте новый проект, название произвольное.
2. Скачайте пакет sonar-scanner, который вам предлагает скачать SonarQube.
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
4. Проверьте `sonar-scanner --version`.

```bash
alex@ubuntu22:~/PycharmProjects/mnt-homeworks/09-ci-03-cicd/example$ sonar-scanner --version
INFO: Scanner configuration file: /home/alex/sonarqube/sonar-scanner-cli-5.0.1.3006-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 5.0.1.3006
INFO: Java 17.0.7 Eclipse Adoptium (64-bit)
INFO: Linux 6.5.0-17-generic amd64
```


5. Запустите анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`.
```bash
~~~~
INFO: ------------- Run sensors on project
INFO: Sensor Zero Coverage Sensor
INFO: Sensor Zero Coverage Sensor (done) | time=4ms
INFO: SCM Publisher SCM provider for this project is: git
INFO: SCM Publisher 1 source file to be analyzed
INFO: SCM Publisher 0/1 source files have been analyzed (done) | time=79ms
WARN: Missing blame information for the following files:
WARN:   * fail.py
WARN: This may lead to missing/broken features in SonarQube
INFO: CPD Executor Calculating CPD for 1 file
INFO: CPD Executor CPD calculation finished (done) | time=4ms
INFO: Analysis report generated in 44ms, dir size=103.1 kB
INFO: Analysis report compressed in 10ms, zip size=14.4 kB
INFO: Analysis report uploaded in 60ms
INFO: ANALYSIS SUCCESSFUL, you can browse http://51.250.6.201:9000/dashboard?id=Netology
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://51.250.6.201:9000/api/ce/task?id=AY2uc1-shvyzIkSYNpBN
INFO: Analysis total time: 3.562 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 4.297s
INFO: Final Memory: 9M/48M
INFO: ------------------------------------------------------------------------

```
6. Посмотрите результат в интерфейсе.
7. Исправьте ошибки, которые он выявил, включая warnings.

![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-03-cidi/09-ci-03-cicd/img/Screenshot%20from%202024-02-15%2023-15-51.png?raw=true)

8. Запустите анализатор повторно — проверьте, что QG пройдены успешно.
9. Сделайте скриншот успешного прохождения анализа, приложите к решению ДЗ.

![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-03-cidi/09-ci-03-cicd/img/Screenshot%20from%202024-02-15%2023-27-23.png?raw=true)

## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-public` загрузите артефакт с GAV-параметрами:

 *    groupId: netology;
 *    artifactId: java;
 *    version: 8_282;
 *    classifier: distrib;
 *    type: tar.gz.
   
2. В него же загрузите такой же артефакт, но с version: 8_102.
3. Проверьте, что все файлы загрузились успешно.

![screenshot](https://github.com/AlexeyD3/mnt-homeworks/blob/ci-03-cidi/09-ci-03-cicd/img/Screenshot%20from%202024-02-15%2023-59-48.png?raw=true)

4. В ответе пришлите файл `maven-metadata.xml` для этого артефекта.
```xml
<metadata modelVersion="1.1.0">
<groupId>netology</groupId>
<artifactId>java</artifactId>
<versioning>
<latest>8_282</latest>
<release>8_282</release>
<versions>
<version>8_282</version>
</versions>
<lastUpdated>20240215203913</lastUpdated>
</versioning>
</metadata>
```

### Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с [maven](https://maven.apache.org/download.cgi).
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.
4. Проверьте `mvn --version`.

```bash
alex@ubuntu22:~$ mvn --version
Apache Maven 3.9.6 (bc0240f3c744dd6b6ec2920b3cd08dcc295161ae)
Maven home: /home/alex/sonarqube/apache-maven-3.9.6-bin/apache-maven-3.9.6
Java version: 1.8.0_392, vendor: Private Build, runtime: /usr/lib/jvm/java-8-openjdk-amd64/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "6.5.0-17-generic", arch: "amd64", family: "unix"

```

5. Заберите директорию [mvn](./mvn) с pom.

### Основная часть

1. Поменяйте в `pom.xml` блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).
2. Запустите команду `mvn package` в директории с `pom.xml`, ожидайте успешного окончания.
3. Проверьте директорию `~/.m2/repository/`, найдите ваш артефакт.
4. В ответе пришлите исправленный файл `pom.xml`.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
