FROM r-base:latest

# Устанавливаем dplyr при сборке (для ускорения)
RUN R -e "install.packages('dplyr', repos='https://cloud.r-project.org')"

# Копируем R скрипт
COPY script.R /app/script.R

# Устанавливаем рабочую директорию
WORKDIR /app

# Запуск скрипта при старте контейнера
CMD ["Rscript", "script.R"]