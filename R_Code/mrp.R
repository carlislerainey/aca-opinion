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

### add variables to poll.data
poll.data$month.year <- interaction(d$month, d$year)


################################################################################
## Prepare Census Data
################################################################################

# prepare the census data
data(mrp.census)
mrp.census <- within(mrp.census,{
  state <- factor(state)
  race <- factor(race,exclude=NA)
  levels(income)[levels(income)=="$75,000-$150,000"] <- "$75,000+"
  levels(income)[levels(income)=="$150,000+"] <- "$75,000+"
  income <- factor(income, exclude = NA, labels = c("less than $20,000", "$20,000-$40,000",
                                                    "$40,000-$75,000", "$75,000+"))
  sex.race <- interaction(sex, race)
})
mrp.census <- na.omit(mrp.census)

years <- unique(poll.data$year)
months <- unique(poll.data$month)

# expand census data set with time indicators
mrp.census.new <- NULL
for (i in 1:length(years)) {
  print(paste("--", years[i]))
  for (j in 1:length(months)) {
    print(paste("------", months[j]))
    mrp.census.temp <- mrp.census
    mrp.census.temp$year <- factor(years[i])
    mrp.census.temp$month <- factor(months[j])
    mrp.census.temp$month.year <- factor(paste(months[j], years[i], sep = "."))
    mrp.census.new <- rbind(mrp.census.new, mrp.census.temp)
  }
}
mrp.census <- mrp.census.new
rm(mrp.census.new, mrp.census.temp)




################################################################################
## Mister P.
################################################################################

mrp.est <- mrp(aca.fav ~ state + month.year,# sex+ race + sex.race + age + education + income,
               data=poll.data,
               population=mrp.census,
               pop.weights="weighted2008",
               grouplevel.data.frames = list(obama2012),
               formula.model.update = .~. + obama_share_12,
)
ps <- 100*poststratify(mrp.est, ~ state + month.year + year)
round(ps, 0)
#AIC(slot(mrp.est, "multilevelModel"))

mrp.est0 <- mrp(aca.fav ~ state + income,# sex+ race + sex.race + age + education + income,
               data=poll.data,
               population=mrp.census,
               pop.weights="weighted2008",
               grouplevel.data.frames = list(obama2012),
               formula.model.update = .~. + obama_share_12,
)
ps0 <- 100*poststratify(mrp.est0, ~ state)
sort(round(ps0, 0))

eplot(xlim = c(0, 100), ylim = c(0, 52), anny = FALSE)
abline(v = 50)
abline(h = 1:51, lty = 3, col = "grey70")
points(ps[order(ps)], 1:51, pch = 19)
points(ps0[order(ps)], 1:51, pch = 21, bg = "white")

text(ps[order(ps)], 1:51, names(ps[order(ps)]), pos = 4, cex = .5)

# write data
mrp.data <- data.frame(ps, names(ps), row.names = 1:length(ps))
colnames(mrp.data) <- c("percent_favorable_aca", "state_abbr")
write.csv(mrp.data, "Data/mrp_est.csv", row.names = FALSE)

# create figures
# source("R_Code/create_figures.R")

