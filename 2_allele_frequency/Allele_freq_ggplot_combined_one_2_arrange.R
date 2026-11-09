#If the library has not been previously installed, run : install.packages("ggplot2")
library(ggplot2)
library(gridExtra)
library(grid)

#First setwd("Wheregetget the file is")
#Get all the files in the current directory
# 凡例を抽出する関数
get_legend <- function(myggplot) {
  tmp <- ggplotGrob(myggplot)
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

LIBS <- list.files()

plots <- list()
legend <- NULL

for (i in 1:length(LIBS)) {
  name <- strsplit(LIBS[i], "_20X_ggplot", fixed = TRUE)[[1]][1]
  Table <- read.csv(LIBS[i], header = TRUE, sep = "\t")
  
  if (nrow(Table) != 0) {
    p <- ggplot(Table, aes(freq)) +
      xlim(0, 1) +
      geom_histogram(aes(fill = rank), binwidth = 0.015) +
      scale_fill_manual(
        values = c(
          first  = "#E69F00",  # オレンジ
          second = "#56B4E9",  # 水色
          third  = "#009E73"   # 緑
        ),
        name = "Rank"
      ) +
      ggtitle(name)
    
    if (is.null(legend)) {
      legend <- get_legend(p)  # 最初のプロットから凡例を抽出
    }
    
    # 凡例を非表示にしてプロットを保存
    p <- p + theme(legend.position = "none")
    plots[[length(plots) + 1]] <- p
  }
}

# 必要なら空プロットで埋める（ちょうど20個にするため）
if (length(plots) < 20) {
  empty_plot <- ggplot() + theme_void()
  plots <- c(plots, rep(list(empty_plot), 20 - length(plots)))
} else if (length(plots) > 20) {
  plots <- plots[1:20]  # 多すぎたら20個に制限（必要に応じて調整可）
}

# グラフ本体（5列 × 4行）
plot_matrix <- arrangeGrob(grobs = plots, ncol = 4, nrow = 5)

# PNG出力（サイズは自由に調整可、ここでは14×18インチ）
png("allele_freq_combined_one.png", width = 14, height = 18, units = "in", res = 300)

# グラフ + 凡例を1ページにまとめる
print(grid.arrange(
  plot_matrix,
  legend,
  nrow = 2,
  heights = c(10, 1)  # 凡例を小さく配置
))

dev.off()