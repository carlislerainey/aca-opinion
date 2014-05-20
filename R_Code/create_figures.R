# clear workspace
rm(list = ls())

# set working directory
setwd("~/Dropbox/Projects/ACA_Opinion")

# load packages
library(compactr)
library(maps)
library(maps)

# draw line plot
d <- read.csv("Data/mrp_est.csv")
fav <- d$percent_favorable_aca
ord <- order(fav)
fav <- fav[ord]
st <- d$state[ord]

png("Figures/mrp_est.png", height = 7, width = 6, units = "in", res = 72)
par(mfrow = c(1,1), oma = c(0,0,0,0), mar = c(3,1,1,1))
eplot(xlim = mm(fav), ylim = c(0, 52), anny = FALSE,
      xlab = "Percent Who View ACA Favorably")
abline(v = .5)
abline(h = 1:51, lty = 3, col = "grey70")
points(fav, 1:51, pch = 19)
pos <- rep(4, length(fav))
pos[length(pos)] <- 2
text(fav, 1:51, st, pos = pos, cex = .70)
dev.off()

# draw map
states <- map_data("state")
d <- read.csv("Data/mrp_est.csv")
state.names <- read.csv("Data/Aggregate_Data/state_names.csv", stringsAsFactors = FALSE)[, c("full", "abbr")]
names(state.names) <- c("state", "state_abbr")
d <- join(d, state.names)
names(d) <- tolower(names(d))
d$region <- tolower(d$state)
choro <- merge(states, d, by = "region")
choro <- choro[order(choro$order), ]
png("Figures/mrp_est_map.png", height = 4, width = 10, units = "in", res = 72)
par(mfrow = c(1,1), oma = c(0,0,0,0),mar = c(1,1,1,1))
q <- qplot(long, lat, data = choro, group = group,
      fill = percent_favorable_aca, geom = "polygon")
q <- q + scale_fill_gradient2(midpoint = 50, low = "#543005", mid = "#f5f5f5", high = "#003c30", name = "% Favorable to ACA")
q <- q +  theme(panel.background = element_blank(), 
                panel.grid = element_blank(),
                axis.ticks = element_blank(),
                axis.title = element_blank(),
                axis.ticks = element_blank(),
                axis.text = element_blank())
q + coord_equal()
dev.off()
