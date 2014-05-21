# clear workspace
# rm(list = ls())

# set working directory
setwd("~/Dropbox/Projects/ACA_Opinion")

# load packages
library(compactr)
library(maps)
library(maps)
library(ggplot2)
library(gridExtra)

### draw line plot
d <- read.csv("Data/mrp_est.csv")
fav <- d$percent_favorable_aca
ord <- order(fav)
fav <- fav[ord]
st <- d$state_abbr[ord]

png("Figures/mrp_est.png", height = 6, width = 8, units = "in", res = 100)
par(mfrow = c(1,3), oma = c(0,0,0,0), mar = c(3,1,1,1))

# percent_favorble_aca
d <- read.csv("Data/mrp_est.csv")
fav <- d$percent_favorable_aca
ord <- order(fav)
fav <- fav[ord]
st <- d$state_abbr[ord]
eplot(xlim = mm(fav), ylim = c(0, 52), anny = FALSE,
      xlab = "Percent Who View ACA Favorably")
abline(v = 50)
abline(h = 1:51, lty = 3, col = "grey70")
points(fav, 1:51, pch = 19)
pos <- rep(4, length(fav))
pos[length(pos)] <- 2
text(fav, 1:51, st, pos = pos, cex = .70)

# percent_supporting_expansion
d <- read.csv("Data/mrp_est.csv")
fav <- d$percent_supporting_expansion
ord <- order(fav)
fav <- fav[ord]
st <- d$state_abbr[ord]
eplot(xlim = mm(fav), ylim = c(0, 52), anny = FALSE,
      xlab = "Percent Supporting the Medicaid Expansion")
abline(v = 50)
abline(h = 1:51, lty = 3, col = "grey70")
points(fav, 1:51, pch = 19)
pos <- rep(4, length(fav))
pos[length(pos)] <- 2
text(fav, 1:51, st, pos = pos, cex = .70)

# percent_supporting_tea_party
d <- read.csv("Data/mrp_est.csv")
fav <- d$percent_supporting_tea_party
ord <- order(fav)
fav <- fav[ord]
st <- d$state_abbr[ord]
eplot(xlim = mm(fav), ylim = c(0, 52), anny = FALSE,
      xlab = "Percent Supporting the Tea Party")
abline(v = 5)
abline(h = 1:51, lty = 3, col = "grey70")
points(fav, 1:51, pch = 19)
pos <- rep(4, length(fav))
pos[c(length(pos) - 1, length(pos))] <- 2
text(fav, 1:51, st, pos = pos, cex = .70)
dev.off()

### draw map
states <- map_data("state")
d <- read.csv("Data/mrp_est.csv")
state.names <- read.csv("Data/Aggregate_Data/state_names.csv", stringsAsFactors = FALSE)[, c("full", "abbr")]
names(state.names) <- c("state", "state_abbr")
d <- join(d, state.names)
names(d) <- tolower(names(d))
d$region <- tolower(d$state)
choro <- merge(states, d, by = "region")
choro <- choro[order(choro$order), ]
png("Figures/mrp_est_map.png", height = 2, width = 12, units = "in", res = 100)
par(mfrow = c(1,3), oma = c(0,0,0,0),mar = c(0,0,0,0))
# aca fav
q <- qplot(long, lat, data = choro, group = group,
      fill = percent_favorable_aca, geom = "polygon",
           main = "Percent Favorable to ACA")
q <- q + scale_fill_gradient2(midpoint = 50, low = "#543005", mid = "#f5f5f5", high = "#003c30", name = "% Favorable to ACA")
q <- q +  theme(panel.background = element_blank(), 
                panel.grid = element_blank(),
                axis.ticks = element_blank(),
                axis.title = element_blank(),
                axis.ticks = element_blank(),
                axis.text = element_blank())
q <- q + guides(fill = guide_colorbar(barwidth = 0.5, barheight = 6, title = NULL))
plot1 <- q + coord_equal()
# expand medicaid
q <- qplot(long, lat, data = choro, group = group,
           fill = percent_supporting_expansion, geom = "polygon",
           main = "Percent Supporting the Medicaid Expansion")
q <- q + scale_fill_gradient2(midpoint = 50, low = "#543005", mid = "#f5f5f5", high = "#003c30", name = "% Supporting Expansion")
q <- q +  theme(panel.background = element_blank(), 
                panel.grid = element_blank(),
                axis.ticks = element_blank(),
                axis.title = element_blank(),
                axis.ticks = element_blank(),
                axis.text = element_blank())
q <- q + guides(fill = guide_colorbar(barwidth = 0.5, barheight = 6, title = NULL))
plot2 <- q + coord_equal()
# aca fav
q <- qplot(long, lat, data = choro, group = group,
           fill = percent_supporting_tea_party, geom = "polygon",
           main = "Percent Supporting the Tea Party")
q <- q + scale_fill_gradient2(midpoint = 50, low = "#543005", mid = "#f5f5f5", high = "#003c30", name = "% Supporting Tea Party")
q <- q +  theme(panel.background = element_blank(), 
                panel.grid = element_blank(),
                axis.ticks = element_blank(),
                axis.title = element_blank(),
                axis.ticks = element_blank(),
                axis.text = element_blank())
q <- q + guides(fill = guide_colorbar(barwidth = 0.5, barheight = 6, title = NULL))
plot3 <- q + coord_equal()
grid.arrange(plot1, plot2, plot3, ncol = 3)
dev.off()
