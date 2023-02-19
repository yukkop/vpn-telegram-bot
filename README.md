# VPNster bot

## Project setup:

--------------------------
## Запустить source service (curent git repo)

Подключиться к консоли сервера (например использовав утилиту ssh)

Использовать команду 

`git clone <path>`

Перейти в папку VPNster

`cd VPNster`

Прописать команду если используете Arch сервер

`docker compose up --build`

или если используете Ubuntu сервер

`docker-compose up --build`

---------------------------------
## Запустить bot service

Подключиться к консоли сервера (например использовав утилиту ssh)

Использовать команду 

`git clone <path>`

Перейти в папку VPNster

`cd VPNster`

При необходимости изменить содержимое конфиг файла config.yaml

Прописать команду если используете Arch сервер

`docker compose up --build`

или если используете Ubuntu сервер

`docker-compose up --build`

-----------------------------
`config.yaml`:
```
botToken: '<bot token>'
botUrl: 'https://t.me/<bot name>'
layoutsPath: 'layouts.yaml'
iokassaToken: '<iokassa token>'
backend:
  host: '<host>'
  port: '<port>'
```