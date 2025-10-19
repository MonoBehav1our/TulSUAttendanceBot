# Запуск через Docker

## Быстрый старт

1. **Скопируйте пример конфигурации:**
   ```bash
   cp env-example-docker .env
   ```

2. **Заполните переменные в `.env`:**
   Откройте файл `.env` и укажите:
   - `TOKEN` - токен вашего бота от @BotFather
   - `CHAT_ID` - ID группы Telegram
   - `GROUP_ID` - номер учебной группы
   - `ADMIN_COMMANDS_ACCESS` - ID администраторов через запятую

3. **Запустите бота:**
   ```bash
   docker-compose up -d
   ```

## Команды управления

```bash
# Запуск в фоне
docker-compose up -d

# Просмотр логов
docker-compose logs -f

# Остановка
docker-compose down

# Пересборка образа
docker-compose build --no-cache

# Полная пересборка и запуск
docker-compose up --build -d
```

## Структура файлов

- `Dockerfile` - инструкции для сборки контейнера
- `docker-compose.yml` - конфигурация сервиса
- `.dockerignore` - исключения для контекста сборки
- `env-example-docker` - пример конфигурации переменных окружения

## Volumes

Контейнер использует volumes для:
- `tulsu_bot_db` - **named volume** для базы данных SQLite (сохраняется между перезапусками)
- `./logs` - директория для логов (опционально, bind mount)

### Важно про базу данных

База данных использует **named volume** `tulsu_bot_db` для кросс-платформенной совместимости. Это решает проблемы с путями на Windows.

**Для просмотра/резервного копирования базы данных:**
```bash
# Найти контейнер
docker ps

# Скопировать базу из volume
docker cp <container_name>:/app/db.sqlite3 ./db_backup.sqlite3

# Или для named volume можно использовать:
docker run --rm -v tulsu_bot_db:/data alpine cat /data > ./db_backup.sqlite3
```

**Для очистки базы данных:**
```bash
docker-compose down
docker volume rm tulsuattendancebot_tulsu_bot_db
docker-compose up -d
```

## Переменные окружения

Все настройки бота передаются через переменные окружения. Основные:

| Переменная | Описание | Пример |
|------------|----------|--------|
| `TOKEN` | Токен бота | `123456:ABC...` |
| `CHAT_ID` | ID группы | `-12345` |
| `GROUP_ID` | Номер группы | `111111` |
| `ADMIN_COMMANDS_ACCESS` | ID админов | `123,1234` |

Полный список переменных смотрите в `env-example-docker`.

## Troubleshooting

**Бот не запускается:**
- Проверьте заполнение всех обязательных переменных в `.env`
- Убедитесь, что токен бота корректный
- Проверьте логи: `docker-compose logs`

**Проблемы с базой данных на Windows:**
- По умолчанию используется named volume `tulsu_bot_db` для кросс-платформенности
- **Если проблемы с volume остались**, установите `USE_LOCAL_DB=true` в `.env` файле
- Это создаст базу данных внутри контейнера (данные не сохранятся при пересоздании контейнера)
- Для сохранения данных используйте: `docker cp <container>:/app/db.sqlite3 ./backup.sqlite3`
- Убедитесь, что Docker Desktop обновлен до последней версии

**База данных не сохраняется:**
- Named volume `tulsu_bot_db` автоматически сохраняет данные
- Для проверки выполните: `docker volume ls | grep tulsu`

**Проблемы с сетью:**
- Убедитесь, что бот имеет доступ в интернет для работы с Telegram API
- На Windows проверьте настройки Firewall для Docker Desktop

**Контейнер падает сразу после запуска:**
- Проверьте логи: `docker-compose logs tulsu-attendance-bot`
- Убедитесь, что все переменные окружения корректны
- Попробуйте запуск без `-d`: `docker-compose up` для просмотра вывода в реальном времени
