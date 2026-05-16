# Исходники для установки Puppeteer. Взято отсюда:
# https://github.com/buildkite/docker-puppeteer/blob/master/Dockerfile
FROM node:16-slim

RUN apt-get update && apt-get install -y \
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


# Папка приложения
WORKDIR /app

# Установка зависимостей
COPY package*.json ./
RUN npm install
# Для использования в продакшне
# RUN npm install --production

# Копирование файлов проекта
COPY . .

# Уведомление о порте, который будет прослушивать работающее приложение
EXPOSE 5000

# Запуск проекта
# CMD [ "node", "index.js" ]
CMD ["npm", "start"]
