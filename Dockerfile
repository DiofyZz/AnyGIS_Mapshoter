# Используем стабильный образ Node.js 16 на базе Debian 11 (Bullseye)
FROM node:16-bullseye-slim

# Обновляем списки пакетов и устанавливаем:
# 1. Зависимости для компиляции C++ модулей (python3, make, g++) - для библиотеки sharp
# 2. Графические зависимости для Chromium/Puppeteer
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    wget \
    gnupg \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxtst6 \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libxss1 \
    libasound2 \
    libdrm2 \
    libgbm1 \
    libpangocairo-1.0-0 \
    libxshmfence1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Создаем рабочую директорию внутри контейнера
WORKDIR /app

# Сначала копируем только файлы с зависимостями (для кэширования слоя Docker)
COPY package*.json ./

# Устанавливаем зависимости Node.js
RUN npm install

# Копируем все остальные исходники проекта
COPY . .

# Сообщаем Docker, что контейнер будет слушать 5000 порт
EXPOSE 5000

# Команда запуска сервиса
CMD ["node", "--experimental-worker", "App/Main.js"]
