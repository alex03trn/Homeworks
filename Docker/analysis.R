
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
