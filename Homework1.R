motifs2 <- matrix(c(
  "a", "C", "g", "G", "T", "A", "A", "t", "t", "C", "a", "G",
  "t", "G", "G", "G", "C", "A", "A", "T", "t", "C", "C", "a",
  "A", "C", "G", "t", "t", "A", "A", "t", "t", "C", "G", "G",
  "T", "G", "C", "G", "G", "G", "A", "t", "t", "C", "C", "C",
  "t", "C", "G", "a", "A", "A", "A", "t", "t", "C", "a", "G",
  "A", "C", "G", "G", "C", "G", "A", "a", "t", "T", "C", "C",
  "T", "C", "G", "t", "G", "A", "A", "t", "t", "a", "C", "G",
  "t", "C", "G", "G", "G", "A", "A", "t", "t", "C", "a", "C",
  "A", "G", "G", "G", "T", "A", "A", "t", "t", "C", "C", "G",
  "t", "C", "G", "G", "A", "A", "A", "a", "t", "C", "a", "C"
), nrow = 10, byrow = TRUE)

#Преобразуйте матрицу в верхний регистр (toupper())
motifs_upper <- apply(motifs2, 2, toupper)
motifs_upper

#создание count матрицы
count_matrix <- apply(motifs_upper, 2, function(col) table(factor(col, levels = c("A", "C", "G", "T"))))

#создание profile матрицы

profile_matrix <- apply(motifs_upper, 2, function(x) {
  counts <- table(factor(x, levels = c("A", "C", "G", "T")))
  counts / sum(counts)
})

count_matrix
profile_matrix

#вычисление score для матрицы
scoreMotifs <- function(motifs) {
  motifs <- matrix(toupper(motifs), nrow = nrow(motifs))
  sum(apply(motifs, 2, function(col) length(col) - max(table(col))))
}

scoreMotifs(motifs_upper)

#определение консенсунс последовательности для матрицы
consensus <- apply(profile_matrix, 2, function(col) {
  nucleotides <- c("A", "C", "G", "T")
  nucleotides[which.max(col)]
})
consensus_string <- paste(consensus, collapse = "")

consensus_string

#построение графика частот нукл в 1 столбце
col1 <- motifs_upper[, 1]
freq_nucl <- table(col1)
barplot(freq_nucl,
        col = "skyblue",
        main = "Частоты нуклеотидов в 1-м столбце",
        xlab = "Нуклеотиды",
        ylab = "Частота")