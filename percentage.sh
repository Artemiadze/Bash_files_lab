#!/bin/bash

   # Укажите тут путь к вашей папке фиксированного размера
   MOUNTPOINT=mountpoint/log

   # Извлекаем процент использования
   size=$(df "$MOUNTPOINT" | awk 'NR==2 {print $5}')

   # Выводим результат
   echo "Процент использования папки '$MOUNTPOINT': $size"
