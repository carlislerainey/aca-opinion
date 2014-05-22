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
state.names <- read.csv("Data/Aggregate_Data/state_names.csv", stringsAsFactors = FALSE)
obama2012 <- read.csv("Data/Aggregate_Data/obama2012.csv", stringsAsFactors = FALSE)
region <- read.csv("Data/Aggregate_Data/region.csv", stringsAsFactors = FALSE)
poll.data <- read.csv("Data/poll_data.csv")
poll.data <- poll.data[poll.data$year == 2012, ]
poll.data$sex.race <- interaction(poll.data$sex, poll.data$race)

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

# aca favorability
mrp.aca.fav <- mrp(aca.fav ~ state + sex + race + sex.race + age + education + income,
               data=poll.data,
               population=mrp.census,
               pop.weights="weighted2008",
               grouplevel.data.frames = list(obama2012, region),
               formula.model.update = .~. + obama_share_12 + (1 | region),
)
ps.aca.fav <- 100*poststratify(mrp.aca.fav, ~ state)
sort(round(ps.aca.fav, 0))
#AIC(slot(mrp.est, "multilevelModel"))
eplot(xlim = c(0, 100), ylim = c(0, 52), anny = FALSE, main = "ACA Favorability")
abline(v = 50)
abline(h = 1:51, lty = 3, col = "grey70")
points(ps.aca.fav[order(ps.aca.fav)], 1:51, pch = 19)
text(ps.aca.fav[order(ps.aca.fav)], 1:51, names(ps.aca.fav[order(ps.aca.fav)]), pos = 4, cex = .5)

# tea party
mrp.tea.party <- mrp(tea.party ~ state + sex + race + sex.race + age + education + income,
                   data=poll.data,
                   population=mrp.census,
                   pop.weights="weighted2008",
                   grouplevel.data.frames = list(obama2012, region),
                   formula.model.update = .~. + obama_share_12 + (1 | region),
)
ps.tea.party <- 100*poststratify(mrp.tea.party, ~ state)
sort(round(ps.tea.party, 0))
#AIC(slot(mrp.est, "multilevelModel"))
eplot(xlim = c(0, 100), ylim = c(0, 52), anny = FALSE, main = "Tea Party")
abline(v = 50)
abline(h = 1:51, lty = 3, col = "grey70")
points(ps.tea.party[order(ps.tea.party)], 1:51, pch = 19)
text(ps.tea.party[order(ps.tea.party)], 1:51, names(ps.tea.party[order(ps.tea.party)]), pos = 4, cex = .5)

# expand medicaid
mrp.exp.medicaid <- mrp(exp.medicaid ~ state + sex + race + sex.race + age + education + income,
                   data=poll.data,
                   population=mrp.census,
                   pop.weights="weighted2008",
                   grouplevel.data.frames = list(obama2012, region),
                   formula.model.update = .~. + obama_share_12 + (1 | region),
)
ps.exp.medicaid <- 100*poststratify(mrp.exp.medicaid, ~ state)
sort(round(ps.exp.medicaid, 0))
#AIC(slot(mrp.est, "multilevelModel"))
eplot(xlim = c(0, 100), ylim = c(0, 52), anny = FALSE, main = "Support Expanding Medicaid")
abline(v = 50)
abline(h = 1:51, lty = 3, col = "grey70")
points(ps.exp.medicaid[order(ps.exp.medicaid)], 1:51, pch = 19)
text(ps.exp.medicaid[order(ps.exp.medicaid)], 1:51, names(ps.exp.medicaid[order(ps.exp.medicaid)]), pos = 4, cex = .5)

# write data
mrp.data.aca.fav <- data.frame(state_abbr = names(ps.aca.fav), percent_favorable_aca = ps.aca.fav, row.names = 1:length(ps.aca.fav))
mrp.data.exp.medicaid <- data.frame(state_abbr = names(ps.exp.medicaid), percent_supporting_expansion = ps.exp.medicaid, row.names = 1:length(ps.exp.medicaid))
mrp.data.tea.party <- data.frame(state_abbr = names(ps.tea.party), percent_supporting_tea_party = ps.tea.party, row.names = 1:length(ps.tea.party))

mrp.data <- join(mrp.data.aca.fav, mrp.data.exp.medicaid)
mrp.data <- join(mrp.data, mrp.data.tea.party)

write.csv(mrp.data, "Data/mrp_est.csv", row.names = FALSE)

# create figures
source("R_Code/create_figures.R")

