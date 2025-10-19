# Используем официальный Python образ
FROM python:3.11-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файл с зависимостями и устанавливаем их
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем исходный код
COPY . .

# Создаем директорию для базы данных (если нужно)
RUN mkdir -p /app/data

# Указываем, что контейнер слушает на порту 80 (для healthcheck, если понадобится)
EXPOSE 80

# Команда запуска бота
CMD ["python", "main.py"]
