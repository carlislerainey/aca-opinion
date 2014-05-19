# clear workspace
rm(list = ls())

# set working directory
setwd("~/Dropbox/Projects/ACA_Opinion")

# load packages
#library(devtools)
#install_github("mrp", "malecki", sub="mrpdata")
#install_github("mrp", "malecki", sub="mrp")
library(foreign)
library(mrp)
library(mrpdata)
library(compactr)

################################################################################
## Clean and Load Poll Data and Load State-Level Predictors
################################################################################

source("R_Code/clean_poll_data.R")
source("R_Code/merge_poll_data.R")
poll.data <- read.csv("Data/poll_data.csv")
state.names <- read.csv("Data/Aggregate_Data/state_names.csv", stringsAsFactors = FALSE)
obama2012 <- read.csv("Data/Aggregate_Data/obama2012.csv", stringsAsFactors = FALSE)
region <- read.csv("Data/Aggregate_Data/region.csv", stringsAsFactors = FALSE)


################################################################################
## Prepare Census Data
################################################################################

# prepare the census data
data(mrp.census)
mrp.census <- within(mrp.census,{
  race <- factor(race,exclude=NA)
  levels(income)[levels(income)=="$75,000-$150,000"] <- "$75,000+"
  levels(income)[levels(income)=="$150,000+"] <- "$75,000+"
  cat(levels(income))
  income <- factor(income, exclude = NA, labels = c("less than $20,000", "$20,000-$40,000",
                                                    "$40,000-$75,000", "$75,000+"))
  sex.race <- interaction(sex, race)
})
mrp.census <- na.omit(mrp.census)

################################################################################
## Mister P.
################################################################################

mrp.est <- mrp(aca.fav ~ state,
               data=poll.data,
               population=mrp.census,
               pop.weights="weighted2008",
               grouplevel.data.frames = list(obama2012),
               formula.pop.update = .~. -month,
               formula.model.update = .~. + obama_share_12,
)
ps <- 100*poststratify(mrp.est, ~ state)
sort(round(ps, 0))


eplot(xlim = c(0, 1), ylim = c(0, 52), anny = FALSE)
abline(v = .5)
abline(h = 1:51, lty = 3, col = "grey70")
points(ps[order(ps)], 1:51, pch = 19)
text(ps[order(ps)], 1:51, names(ps[order(ps)]), pos = 4, cex = .5)

mrp.data <- data.frame(ps, names(ps), row.names = 1:length(ps))
colnames(mrp.data) <- c("percent_favorable_aca", "state_abbr")
write.csv(mrp.data, "Data/mrp_est.csv", row.names = FALSE)
