Bingo project
========

## Структурная схема 

PostgresSQL <---> Bingo beckend <---> Nginx frontend

## Общее описание

- Для работы над проектом было создано два окружения Dev и Prod.
- Dev окружение было развернуто на локальном ПК на нем проводилось первоначальное тестирование элементов системы.
- Prod окружение развернуто в YaCloud в него выкатывались протестированный в Dev "релиз".

## Dev окружение

Для реализации всех компонентов (DB, Backend, Frontend) Dev окружения используется docker-compose.  В Dev окружении используется одна нода для сервиса приложения. Все компоненты тестировались на локальном ПК.

### Исследование бинарника приложения
Добавлены права на выполнение файла

```
chmod +x ./bingo
```
исследована справка

```
─[$] ./bingo --help                                                                                                                     
bingo

Usage:
   [flags]
   [command]

Available Commands:
  completion           Generate the autocompletion script for the specified shell
  help                 Help about any command
  prepare_db           prepare_db
  print_current_config print_current_config
  print_default_config print_default_config
  run_server           run_server
  version              version

Flags:
  -h, --help   help for this command

Use " [command] --help" for more information about a command.
```
после выполнения команды `./bingo print_default_confi` стала известна структура конфигурационного файла

```
student_email: test@example.com
postgres_cluster:
  hosts:
  - address: localhost
    port: 5432
  user: postgres
  password: postgres
  db_name: postgres
  ssl_mode: disable
  use_closest_node: false
```


исследован бинарник `bingo` с помощью `strace`
```
strace -t ./bingo run_server
```
в выводе найдены файлы и их местоположение к которым он обращается
созданы необходимые файлы для запуска приложения

после успешного запуска найден порт который слушает приложение

```
lsof -nP -iTCP -sTCP:LISTEN
```
теперь можно подготовить докерфайл для сборки имеджа `bingo`

### Подготовка docker-compose файлов

Подготовлен [dockerfile](https://github.com/iaprokhorov/yapract40/blob/master/bingo-dev/dockerfile) для `bingo`

Подготовлен [docker-compose](https://github.com/iaprokhorov/yapract40/blob/master/bingo-dev/docker-compose.yml) файл для ноды с приложением

В compose входит 5 сервиса:
* bingo
* webserver
* autoheal
* certbot (только в dev, не успел оформить домен для прода)
* vector

!!!Добавить комменты в конфигах!!!

В качестве http сервера фронтенда принял решение использовать `nginx` подготовлены для него [конфиги](https://github.com/iaprokhorov/yapract40/tree/master/bingo-dev/nginx)

Для автоматического перезапуска контейнеров при их падении задействовал образ [autoheal](https://github.com/willfarrell/docker-autoheal)

Для выпуска ssl сертификат [certbot](https://eff-certbot.readthedocs.io/en/stable/install.html)

Для сбора логов настроен [vector](https://vector.dev/)

Подготовлен [docker-compose](https://github.com/iaprokhorov/yapract40/blob/master/postgres/docker-compose.yml) файл для `DB Postgres` в Dev окружении

Запускаем сначала docker-compose файл с ДБ, затем с сервисами для ноды

```
docker-compose up -d
```

## Prod окружение

В Prod окружении сервис развернут на двух нодах c использованием балансировщика нагрузки (Network Load Balancer от YaCloud) для обеспечения требуемой в ТЗ отказоустойчивости приложения. Используется Yandex Managed Service for PostgreSQL для DB и docker-compose для разворачивания микросервисов на обоих нодах.

### Подготовка инфры
Основные компоненты были развернуты в YaCloud с помощью [Terraform](https://github.com/iaprokhorov/yapract40/tree/master/infra) а именно:
* PostgreSQL
* Node-01
* Node-02
* S3 для хранения стейта Terraform
* YDB для блокировки стейта Terraform
* KMS для хранения ключа шифрования от S3
* Network

### Подготовка DB Postgres

В БД включено индексирование таблиц для ускорения запросов.
Подключается к базе с помощью psql и выполняем следующие SQL запросы:
```
CREATE INDEX ix_movies_id ON movies (id);
CREATE INDEX ix_customers_id ON customers (id);
CREATE INDEX ix_sessions_id ON sessions (id);
```

### Подготовка нод
Провиженинг применять не стал т.к. решил что для двух нод проще сделать преднастройку вручную (записал задачу настройки провиженинга в DoTo на будущее :)

Начальная настройка обоих нод для сервиса (обновление ОС, установка docker):
```
sudo apt update && sudo apt upgrade
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce
sudo usermod -aG docker ${USER}
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.14.2/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
```
Создаем на нодах папки для приложений, копируем в них содержимое папок из репозетория [bingo-prod/node-01](https://github.com/iaprokhorov/yapract40/tree/master/bingo-prod/node-01) и [bingo-prod/node-02](https://github.com/iaprokhorov/yapract40/tree/master/bingo-prod/node-02) c подготовленными конфигами
```
mkdir ~/bingo
scp -r ./bingo/ <username>@<host_ip>:~/bingo/
```
Запуск docker-compose файла на каждой ноде
```
docker-compose up -d
```
смотрим состояние контейнеров
```
ubuntu@node-01:~/bingo$ docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS                   PORTS                                                                                  NAMES
c2f14938120a   nginx:alpine3.18                "/docker-entrypoint.…"   9 minutes ago   Up 9 minutes (healthy)   0.0.0.0:80->80/tcp, :::80->80/tcp                                                      webserver
3d76443953e9   yandex/bingo                    "./bingo run_server"     9 minutes ago   Up 9 minutes (healthy)   0.0.0.0:16320->16320/tcp, :::16320->16320/tcp                                          bingo
475efa3ec877   willfarrell/autoheal            "/docker-entrypoint …"   9 minutes ago   Up 9 minutes (healthy)                                                                                          autoheal
bb9be2679a81   timberio/vector:0.34.1-alpine   "/usr/local/bin/vect…"   9 minutes ago   Up 9 minutes            0.0.0.0:8686->8686/tcp, :::8686->8686/tcp, 0.0.0.0:9598->9598/tcp, :::9598->9598/tcp    vector
```


### Отказоустойчивость и автовосстановление

отказоустойчивость и автовосстановление обеспечивается следующими механизмами
на уровне приложения - nginx upstream fail_timeout 
на уровне контейнеров - healthcheck и autoheal
на уровне нод - network load balancer, instanc group


## Мониторинг
Для того чтобы Bingo отправлял логи и не забивал main.log была создана ссылка 
```
ln -sf /dev/stdout /opt/bongo/logs/798fae5531/main.log
```
Логи со всех контейнеров Bingo и Nginx собирает `Vector`. Он же их фильтрует, удаляет лишние поля, парсит json и отравляет в `OpenSearch`
Настройки Vector можно посмотреть в [vector.yaml](https://github.com/iaprokhorov/yapract40/blob/master/bingo-prod/node-01/vector/vector.yaml)
`OpenSearch` поднимается [docker-compose](https://github.com/iaprokhorov/yapract40/blob/master/opensearch/docker-compose.yml) файлом

Сбор метрик и логов с вебсервера nginx реализован средствами `nginx-exporter` + [telegraf](https://github.com/influxdata/telegraf) (так-как он может ещё и логи подтягивать) и [PromStack](https://github.com/Einsteinish/Docker-Compose-Prometheus-and-Grafana), отображение в `Gragana` инфраструктуры с помощью PromStack, но [docker-compose](https://github.com/iaprokhorov/yapract40/blob/master/promstack/docker-compose.yml) файл.
Скриншоты дашбордов из графаны можно посмотреть в [этой папке](https://github.com/iaprokhorov/yapract40/blob/master/screens).
## Тестирование
Для проверок пользовался RPS и времени ответа использовал wrk со следующими параметрами:
```
wrk -t20 -c20 -d60s -L http://<url>
```

~~~
Running 1m test @ http://<ip>/api/session/31
  20 threads and 20 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   114.02ms   87.01ms 647.74ms   84.47%
    Req/Sec    11.70      6.10    30.00     52.03%
  Latency Distribution
     50%   68.16ms
     75%  156.16ms
     90%  235.76ms
     99%  397.19ms
  11723 requests in 1.00m, 4.82MB read
Requests/sec:    195.22
Transfer/sec:     82.17KB
~~~

## Итоги прокета

Что удалось запустить в прод:
- Получилось собрать отказоустойчивую систему на двух нодах обеспечивающую требуемое качество сервиса.
- Настроить централизованный сбор логов и метрик.
- Не удалось настроить https по причине долго оформления домена, в остальном [конфиги](https://github.com/iaprokhorov/yapract40/blob/master/bingo-dev/nginx/conf.d/bingo.conf) все готово для внедрения.

Были найдены 2 кода и успешно пройдены 15 из 19 петиных тестов.  


