
# Libraries

library(dplyr)
library(tidyr)
library(ggplot2)
library(scico)
library(ggrepel)


# Load Data

citationDF <- read.table("../../data/web-sciences-metrics.txt", sep = ",", stringsAsFactors = F, header = T)

# Format

citationDF <- citationDF %>% rename(Name = Name) %>%
    mutate(
        Sum2Y = X2017 + X2018,
        rank = rank(-Total.Citations),
        rank2Y = rank(-Sum2Y, ties.method = "min"),
        delta = rank - rank2Y
    ) %>%
    select(Name, Total.Citations, rank, Sum2Y, rank2Y, delta) %>%
    arrange(rank2Y) %>%
    mutate(
        rankName = paste(rank2Y, Name, sep = "- "),
        rankNameOrdered = factor(rankName, levels = rev(rankName))
    )

# Plot

scatterPlot <- ggplot() + theme_bw(base_size = 18) +
    geom_abline(slope = 1, intercept = 0, col = "grey80", linetype = "dashed") +
    geom_point(data = citationDF, mapping = aes(x = rank, y = rank2Y)) +
    scale_x_reverse(name = "Rank [1995-2018]", expand = c(0, 0), limits = c(nrow(citationDF) + 5, 0)) +
    scale_y_reverse(name = "Rank [2017-2018]", expand = c(0, 0), limits = c(nrow(citationDF) + 5, 0))

png("../citations_rank.png", width = 1600, height = 900)
plot(scatterPlot)
dummy <- dev.off()

maxDelta <- max(citationDF$delta)
minDelta <- min(citationDF$delta)
absDelta <- max(abs(minDelta), maxDelta)
totalLength <- 2 * absDelta

barPlot <- ggplot() + theme_bw(base_size = 18) +
    geom_col(data = citationDF, mapping = aes(x = rankNameOrdered, y = delta, fill = delta), col = "black") +
    scale_fill_scico(palette = "cork", begin = (-absDelta - minDelta) / totalLength, end = 1- (absDelta - maxDelta) / totalLength) +
    coord_flip() +
    scale_y_continuous(name = "Rank Gain") +
    theme(axis.title.y = element_blank())

png("../citations_rank_delta.png", width = 450, height = 800)
plot(barPlot)
dummy <- dev.off()




