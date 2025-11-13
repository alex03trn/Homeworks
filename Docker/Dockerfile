# Используем базовый образ с R
FROM r-base:latest

# Создаём рабочую директорию
WORKDIR /home

# Копируем скрипт и Excel-файл внутрь контейнера
COPY analysis.R /home/analysis.R
COPY пациенты.xlsx /home/пациенты.xlsx

# Создаём папку для результатов
RUN mkdir -p /home/results

# Устанавливаем необходимые R-пакеты
RUN R -e "install.packages(c('readxl', 'dplyr'), repos='https://cloud.r-project.org')"

# Запуск скрипта при старте контейнера
CMD ["Rscript", "/home/analysis.R"]
