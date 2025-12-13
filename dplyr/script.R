library(dplyr)

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr", repos = "https://cloud.r-project.org")
}
library(dplyr)
cat("dplyr version:", as.character(packageVersion("dplyr")), "\n")

set.seed(123)
df_raw <- data.frame(
  sample_id = rep(1:10, each = 5),
  absorbance = rnorm(50, 0.5, 0.1),
  temp = rnorm(50, 37, 0.5),
  measurement_error = rnorm(50, 0, 0.05)
)

detailed_stats <- df_raw %>%
  group_by(sample_id) %>%
  summarize(
    across(
      c(absorbance, temp, measurement_error),
      list(mean = mean, sd = sd, min = min, max = max),
      .names = "{.col}_{.fn}"
    ),
    .groups = "drop"
  )

dir.create("data", showWarnings = FALSE)
write.csv(df_raw, file = "data/raw_data.csv", row.names = FALSE)
write.csv(detailed_stats, file = "data/detailed_stats.csv", row.names = FALSE)

# Разделяем на левый и правый датафреймы
df_left <- df_raw %>% filter(sample_id <= 7)
df_right <- df_raw %>% filter(sample_id >= 5)

# Anti joins 
anti_left <- df_left %>% anti_join(df_right, by = "sample_id")   # строки из левого, которых нет в правом
anti_right <- df_right %>% anti_join(df_left, by = "sample_id")  # строки из правого, которых нет в левом
anti_outer <- bind_rows(anti_left, anti_right)                   # объединение для outer

# Сохраняем результаты
write.csv(anti_left, file = "data/anti_left.csv", row.names = FALSE)
write.csv(anti_right, file = "data/anti_right.csv", row.names = FALSE)
write.csv(anti_outer, file = "data/anti_outer.csv", row.names = FALSE)

cat("Все файлы сохранены в папку data\n")
