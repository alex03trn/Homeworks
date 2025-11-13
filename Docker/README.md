Состав репозитория Docker:
Пациенты.xlsx — база данных с исходной информацией,
analysis.R — основной R-скрипт для анализа данных,
Dockerfile — инструкция по созданию образа контейнера,
results/ — директория для итогового csv файла (анализ_гемоглобина.csv).


analysis.R содержит следующий код домашнего задания N6: 

library(readxl)
library(dplyr)

# Читаем Excel-файл
patients <- read_excel("пациенты.xlsx")

# Преобразуем переменные
patients$Пол <- factor(patients$Пол, levels = c("м", "ж"))

# Создаём возрастные группы
patients$возраст_группа_2 <- ifelse(patients$Возраст <= 60, "Молодые", "Старшие")

# Создаём копию для работы с NA
patients_task <- patients
patients_task$глюкоза[c(3, 15, 45)] <- NA

# Заменяем пропуски в глюкозе на медиану
patients_task$глюкоза[is.na(patients_task$глюкоза)] <- median(patients_task$глюкоза, na.rm = TRUE)

# Итоговый расчёт среднего и стандартного отклонения гемоглобина по возрастным группам
final_result <- aggregate(гемоглобин ~ возраст_группа_2,
                          data = patients_task,
                          FUN = function(x) c(mean = mean(x), sd = sd(x)))

final_result <- data.frame(
  возраст_группа = final_result$возраст_группа_2,
  Ср_гемоглобин = final_result$гемоглобин[, "mean"],
  Ст_откл_гемоглобин = final_result$гемоглобин[, "sd"]
)

# Создаём папку для вывода и сохраняем результат
output_dir <- "/home/results"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

write.csv(final_result, file.path(output_dir, "анализ_гемоглобина.csv"), row.names = FALSE)

print("Файл 'анализ_гемоглобина.csv' успешно создан в /home/results\n")


Dockerfile содержит следующий код:
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



Для создания Docker-образ использован код:
bash
docker build -t hemoglobin-analysis .

Для запуска контейнер с монтированием папки Result использован код:
bash
docker run --rm -v $(pwd)/Result:/home/results hemoglobin-analysis




