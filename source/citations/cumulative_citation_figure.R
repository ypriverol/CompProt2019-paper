##
#
# This scripts plots the cumulative number of citations for publications based on an export from Thomson Reuters™ Web of Science™.
# Paths are relative to the repository folder.
#
##


# Libraries

library(dplyr)
library(tidyr)
library(ggplot2)
library(scico)


# Load Data

citationRaw <- read.table("data/web-sciences-metrics.txt", sep = ",", stringsAsFactors = F, header = T)

# Format

citationDF <- citationRaw[, paste0("X", 1995:2018)]
citationDF$Name <- citationRaw[, 1]
citationDF$total <- rowSums(citationDF[, paste0("X", 1995:2018)])

citationDF <- citationDF %>%
    arrange(desc(total))

plotDF <- citationDF %>%
    gather(key = "Year", value = "N", paste0("X", 1995:2018)) %>%
    mutate("Year" = as.numeric(substring(Year, 2))) %>%
    replace_na(list(N = 0))


# Get ribbon values

plotDF <- plotDF %>%
    mutate(orderedName = factor(Name, levels = citationDF$Name)) %>%
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
    scale_fill_manual(name = "Publication", values = scico(n = nrow(citationDF), palette = "batlow"), breaks = rev(levels(plotDF$orderedName))) +
    scale_y_continuous(name = "# Citations", expand = c(0, 0), limits = c(0, 1.05 * max(plotDF$y2))) +
    scale_x_continuous(breaks = 1995:2018, expand = c(0, 0)) +
    theme(
        axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.minor.x = element_blank()
    )

png("docs/citations/citations_cumulative.png", width = 800, height = 450)
plot(cumulativePlot)
dummy <- dev.off()

