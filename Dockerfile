# Возвращаемся к Node 12, под который написан код Mapshoter
FROM node:12-slim

# ХАК: Направляем систему в исторический архив Debian, так как Buster устарел.
# Это решит ошибку "404 Not Found" при обновлении.
RUN echo "deb http://archive.debian.org/debian/ buster main" > /etc/apt/sources.list && \
    echo "deb-src http://archive.debian.org/debian/ buster main" >> /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Устанавливаем старый python, инструменты сборки C++ и графические библиотеки
RUN apt-get update && apt-get install -y \
    python \
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

WORKDIR /app

# Копируем файлы зависимостей
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальной код
COPY . .

# Открываем порт
EXPOSE 5000

# Запуск
CMD ["node", "--experimental-worker", "App/Main.js"]
