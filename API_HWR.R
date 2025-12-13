install.packages("httr")
install.packages("jsonlite")

library(httr)
library(jsonlite)

#Получите информацию о 10 белках разной длины. Постройте в R столбчатую диаграмму (barplot), 
#отображающую длину каждого белка.


protein_ids <- c("P69905", "P09874", "P68871", "P01308", "P68871",
                 "P62258", "P15056", "P04150", "P68871", "P35222")

protein_lengths <- numeric(length(protein_ids)) #здесь храним длины белков
protein_names <- character(length(protein_ids)) 

for (i in seq_along(protein_ids)) {
  url <- paste0("https://www.ebi.ac.uk/proteins/api/proteins/", protein_ids[i]) #paste0() нужен только когда URL собирается из частей динамически
  r <- GET(url, accept("application/json"))
  
  if (status_code(r) == 200) {
    data <- fromJSON(content(r, as = "text", encoding = "UTF-8"))
    protein_lengths[i] <- data$sequence$length
    protein_names[i] <- data$protein$recommendedName$fullName$value
  } else {
    protein_lengths[i] <- NA
    protein_names[i] <- protein_ids[i]
  }
}

bar_positions <- barplot(protein_lengths,
                         names.arg = protein_names,
                         las = 2,            
                         col = "skyblue",
                         main = "Длина белков (кол-во аминокислот)",
                         ylab = "Длина белка",
                         ylim = c(0, 1600))

text(x = bar_positions, y = protein_lengths, 
     labels = protein_lengths, pos = 3, cex = 0.8, col = "red")


#Сделайте запрос к Proteins API, чтобы получить данные о белке в формате FASTA. 
#Сохраните результат в файл с расширением .fasta

url <- "https://www.ebi.ac.uk/proteins/api/proteins?accession=P10636"
response <- GET(url, accept("text/x-fasta"))
if (status_code(response) == 200) {
  fasta_file <- "P10636.fasta"
  writeLines(content(response, "text", encoding = "UTF-8"), fasta_file)
  print("FASTA файл сохранен: P10636.fasta")
} else {
  print(paste("Ошибка при запросе. Код ответа:", status_code(response)))
}

