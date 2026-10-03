#!/usr/bin/env bash

INTERVAL=10
LOGFILE="monitor.log"

# 1. Проверка директории
LOGDIR="$(dirname "$LOGFILE")"
if [ ! -d "$LOGDIR" ]; then
    echo "Ошибка: директория '$LOGDIR' не существует" >&2
    exit 1
fi

# 2. Проверка прав на запись в директорию (нужно для создания файла)
if [ ! -w "$LOGDIR" ]; then
    echo "Ошибка: нет прав на запись в '$LOGDIR'" >&2
    exit 1
fi

# 3. Если файл уже существует — проверяем, что в него можно дописывать
if [ -e "$LOGFILE" ] && [ ! -w "$LOGFILE" ]; then
    echo "Ошибка: нет прав на запись в '$LOGFILE'" >&2
    exit 1
fi

# 4. Создаём файл заранее, чтобы ловить проблемы до цикла
touch "$LOGFILE" || {
    echo "Ошибка: не удалось создать/открыть '$LOGFILE'" >&2
    exit 1
}

# 5. Основной цикл с проверкой каждой записи
while true; do
    {
        echo "--- $(date '+%Y-%m-%d %H:%M:%S') ---"
        free -h
        df -h
        uptime
        echo
    } >> "$LOGFILE" 2>/dev/null

    if [ $? -ne 0 ]; then
        echo "Ошибка: не удалось записать в '$LOGFILE' ($(date))" >&2
        exit 1
    fi

    sleep "$INTERVAL"
done
