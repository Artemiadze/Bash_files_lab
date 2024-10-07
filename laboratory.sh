#!/bin/bash
echo "сегодня " `date`

echo -e "\n введите путь к директории и заполненость:"
read path_to
read percentage

echo -e "\n ваша директория содержит файлы и папки:"
ls $path_to

# Получаем размер целевой папки и родительской папки
TARGET_SIZE=$(du -sb "$path_to" | cut -f1)
PARENT_DIR=$(dirname "$path_to")
PARENT_SIZE=$(du -sb "$PARENT_DIR" | cut -f1)

# Проверяем, что размер родительской папки не равен нулю
if [ "$PARENT_SIZE" -eq 0 ]; then
    echo "Ошибка: Размер родительской папки равен нулю."
    exit 1
fi

# Рассчитываем процент
PERCENTAGE_FOLDER=$(echo "scale=2; ($TARGET_SIZE / $PARENT_SIZE) * 100" | bc)

# Выводим результат
echo "Размер '${path_to}' составляет ${PERCENTAGE_FOLDER}% от размера родительской папки '${PARENT_DIR}'."

# Создаем бекап папку, если ее нет
if [ $PERCENTAGE_FOLDER \> $percentage ]; then
    BACKUP_DIR="backup"
    if [ ! -d "$BACKUP_DIR" ]; then
        sudo mkdir "$BACKUP_DIR"
    else
        echo -e "\n Папка уже создана"
    fi

    # Фильтрация и архивация файлов
    num_files=5
    # Находим N самых старых файлов в директории LOG_DIR
    FILES=($(ls -t "$path_to" | tail -n $num_files))

    # Проверяем, найдены ли файлы
    if [ ${#FILES[@]} -eq 0 ]; then
        echo "Нет подходящих файлов для архивации."
        exit 1
    fi

    # Архивируем файлы в директории BACKUP_DIR
    tar -czf "$BACKUP_DIR/old_files_backup.tar.gz" -C "$path_to" "${FILES[@]}"

    # Удаляем файлы из директории LOG_DIR
    for file in "${FILES[@]}"; do
        rm "$path_to/$file"
    done

    echo "Архивация завершена. Архив сохранен как $BACKUP_DIR/old_files_backup.tar.gz и файлы удалены из $path_to."
fi