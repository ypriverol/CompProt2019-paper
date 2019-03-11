
# Libraries

library(dplyr)
library(tidyr)
library(ggplot2)
library(scico)


# Load Data

citationDF <- read.table("../../data/web-sciences-metrics.txt", sep = "\t", stringsAsFactors = F, header = T)

# Format

citationDF <- citationDF %>% 
    rename(Name = X) %>%
    gather(key = "Year", value = "N", paste0("X", 1995:2018)) %>%
    mutate("Year" = as.numeric(substring(Year, 2))) %>%
    replace_na(list(N = 0))


# Separate top 10 from others

top10Lim <- sort(unique(citationDF$Sum), decreasing = T)[10]

top10DF <- citationDF %>% filter(Sum >= top10Lim)
bottomDF <- citationDF %>% filter(Sum < top10Lim)

# Group others by year and merge

otherDF <- bottomDF %>% 
    group_by(Year) %>%
    summarise(
        Name = "Other",
        PMID = paste(PMID, collapse = ", "),
        Sum = sum(Sum),
        Review = 11,
        Update = 11,
        Diff = 0,
        N = sum(N)
    )

plotDF <- rbind(top10DF, otherDF)


# Get ribbon values

orderedSE <- c(unique(top10DF$Name[order(top10DF$Sum, decreasing = T)]), "Other")

plotDF <- plotDF %>%
    mutate(orderedName = factor(Name, levels = orderedSE)) %>%
    group_by(Year) %>%
    arrange(orderedName) %>%
    mutate(
        y2 = cumsum(N),
        y1 = y2 - N
    ) %>%
    ungroup()

# Plot

cumulativePlot <- ggplot() + theme_bw(base_size = 18) +
    geom_ribbon(data = plotDF, mapping = aes(x = Year, ymin = y1, ymax = y2, fill = orderedName)) +
    scale_fill_manual(name = "Search Engine", values = c(scico(n = 10, palette = "batlow"), "grey80"), breaks = rev(orderedSE)) +
    scale_y_continuous(name = "# Citations", expand = c(0, 0), limits = c(0, 1500)) +
    scale_x_continuous(breaks = 1995:2018, expand = c(0, 0)) +
    theme(
        axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.minor.x = element_blank()
    )

png("../cintations_cumulative.png", width = 1600, height = 900)
plot(cumulativePlot)
dummy <- dev.off()

