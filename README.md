# Telegram Proxy

Скрипт для быстрой настройки Telegram Proxy.

Используется [официальный Docker-образ](https://hub.docker.com/r/telegrammessenger/proxy/) от Telegram.

## Как пользоваться

Установите Docker:

```sh
curl -sSL https://get.docker.com/ | sh
```

Склонируйте репозиторий и перейдите в директорию telegram-proxy:

```sh
git clone https://github.com/Imangazaliev/telegram-proxy.git
cd telegram-proxy
```

Выполните команду для запуска прокси:

```sh
./proxy.sh start
```

Посмотрите логи и найдите ссылку для добавления прокси:

```sh
./proxy.sh logs
```


## Команды

- `start` — запустить прокси
- `stop` — остановить прокси
- `status` — статус (запущен / остановлен)
- `remove` — удалить контейнер с прокси
- `logs` — показать логи


## Как указать Promoted-канал
Посмотрите логи и скопируйте значение Secret 1 

```sh
./proxy.sh logs
```

Напишите боту [@MTProxybot](https://t.me/MTProxybot) в Телеграме. Он попросит ввести Secret. Отправьте ему значение из прошлого шага. Бот отправит вам tag. 

Создайте файл .env

```
cp .env.example .env
```

Вставьте secret и tag из прошлых шагов в .env файл. 

Перезапустите прокси:

```sh
./proxy.sh stop && sleep 5 && ./proxy.sh remove && ./proxy.sh start
```

Выполните команду /myproxies в боте [@MTProxybot](https://t.me/MTProxybot) и следуйте инструкции.
