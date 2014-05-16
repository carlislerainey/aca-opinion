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


# load data
sep13 <- read.spss("Data/Kaiser/kaiser_2013_09.por")
aug13 <- read.spss("Data/Kaiser/kaiser_2013_08.por")
jul13 <- read.spss("Data/Kaiser/kaiser_2013_07.por")
jun13 <- read.spss("Data/Kaiser/kaiser_2013_06.por")
may13 <- read.spss("Data/Kaiser/kaiser_2013_05.por")
state.names <- read.csv("Data/state_names.csv", stringsAsFactors = FALSE)
obama2008 <- read.csv("Data/obama2008.csv", stringsAsFactors = FALSE)
obama2012 <- read.csv("Data/obama2012.csv", stringsAsFactors = FALSE)
health <- read.csv("Data/health.csv", stringsAsFactors = FALSE)
region <- read.csv("Data/region.csv", stringsAsFactors = FALSE)

################################################################################
## May 2013
################################################################################

# state
state <- as.character(may13$STATE)
table(state)
temp <- unique(state)
for (i in 1:length(temp)) {
  print(temp[i])
  state[state == temp[i]] <- state.names$abbr[state.names$full == temp[i]]
}
rm(temp)
table(state)

# aca favorability
aca.fav <- may13$Q2
table(aca.fav)
aca.fav <- as.numeric(aca.fav)
table(as.numeric(aca.fav))
aca.fav[aca.fav == 5] <- NA
aca.fav <- 1*(aca.fav <= 2)
table(aca.fav)

# race
race <- may13$RACETHN
table(race)
levels(race)[levels(race)=="White~Hisp"] <- "White"
levels(race)[levels(race)=="AA~Hisp"] <- "Black"
levels(race)[levels(race)=="Hispanic"] <- "Hispanic"
levels(race)[levels(race)=="Other~Hisp"] <- "Other"
race[race=="DK/Ref"] <- NA
race <- factor(race)
table(race)

# income
income <- may13$QD14
table(income)
levels(income)[levels(income)=="Less than $20,000"] <- "less than $20,000"
levels(income)[levels(income)=="$20,000 to less than $30,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$30,000 to less than $40,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$40,000 to less than $50,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$50,000 to less than $75,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$75,000 to less than $90,000"] <- "$75,000+"
levels(income)[levels(income)=="$90,000 to less than $100,000"] <- "$75,000+"
levels(income)[levels(income)=="$100,000 or more"] <- "$75,000+"
income[income == "(DO NOT READ) Don't know/Refused"] <- NA
income <- factor(income)
table(income)

# age
age.years <- may13$QD5
summary(age.years)
age.cat <- may13$QD6
table(age.cat)
age <- rep(NA, length(age.years))
age[age.years >= 18 & age.years <= 29] <- 1
age[age.years >= 30 & age.years <= 44] <- 2
age[age.years >= 45 & age.years <= 64] <- 3
age[age.years >= 65 & age.years < 99] <- 4
age[age.cat == "18-29"] <- 1
age[age.cat == "30-49"] <- 2
age[age.cat == "50-65"] <- 3
age[age.cat == "65+"] <- 4
age <- factor(age, levels = 1:4, labels = c("18-29", "30-44", "45-64", "65+"))
table(age)
rm(age.years); rm(age.cat)

# sex 
sex <- may13$QD1
table(sex)

# education
education <- may13$QD11
table(education)
levels(education)[levels(education)=="None, or grade 1-8"] <- "less than a high school education"
levels(education)[levels(education)=="High school incomplete (grades 9-11)"] <- "less than a high school education"
levels(education)[levels(education)=="High school graduate (grade 12 or GED certificate)"] <- "high school graduate"
levels(education)[levels(education)=="Technical, trade or vocational school AFTER high school"] <- "some college"
levels(education)[levels(education)=="Some college, no four-year degree (includes associate degree)"] <- "some college"
levels(education)[levels(education)=="College graduate (B.S., B.A., or other four-year degree)"] <- "college graduate"
levels(education)[levels(education)=="Four year college or university degree/Bachelor's degree (e.g., BS, BA, AB)"] <- "college graduate"
levels(education)[levels(education)=="Post-graduate or professional schooling after college"] <- "postgraduate"
education[education == "(DO NOT READ) Don't know/Refused"] <- NA
education <- factor(education)
table(education)

# interactions
sex.race <- interaction(sex, race)

# combine variables
may13.data <- data.frame(aca.fav, state, race, income, sex, sex.race, age, education)
may13.data <- na.omit(may13.data)
may13.data$month <- "May"; may13.data$month <- factor(may13.data$month)
may13.data$t <- 6
rm(aca.fav, state, race, income, sex, sex.race, age, education)


################################################################################
## June 2013
################################################################################

# state
state <- as.character(jun13$STATE)
table(state)
temp <- unique(state)
for (i in 1:length(temp)) {
  print(temp[i])
  state[state == temp[i]] <- state.names$abbr[state.names$full == temp[i]]
}
rm(temp)
table(state)

# aca favorability
aca.fav <- jun13$Q1
table(aca.fav)
aca.fav <- as.numeric(aca.fav)
table(as.numeric(aca.fav))
aca.fav[aca.fav == 5] <- NA
aca.fav <- 1*(aca.fav <= 2)
table(aca.fav)

# race
race <- jun13$RACETHN
table(race)
levels(race)[levels(race)=="White~Hisp"] <- "White"
levels(race)[levels(race)=="AA~Hisp"] <- "Black"
levels(race)[levels(race)=="Hispanic"] <- "Hispanic"
levels(race)[levels(race)=="Other~Hisp"] <- "Other"
race[race=="DK/Ref"] <- NA
race <- factor(race)
table(race)

# income
income <- jun13$QD14
table(income)
levels(income)[levels(income)=="Less than $20,000"] <- "less than $20,000"
levels(income)[levels(income)=="$20,000 to less than $30,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$30,000 to less than $40,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$40,000 to less than $50,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$50,000 to less than $75,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$75,000 to less than $90,000"] <- "$75,000+"
levels(income)[levels(income)=="$90,000 to less than $100,000"] <- "$75,000+"
levels(income)[levels(income)=="$100,000 or more"] <- "$75,000+"
income[income == "(DO NOT READ) Don't know/Refused"] <- NA
income <- factor(income)
table(income)

# age
age.years <- jun13$QD5
summary(age.years)
age.cat <- jun13$QD6
table(age.cat)
age <- rep(NA, length(age.years))
age[age.years >= 18 & age.years <= 29] <- 1
age[age.years >= 30 & age.years <= 44] <- 2
age[age.years >= 45 & age.years <= 64] <- 3
age[age.years >= 65 & age.years < 99] <- 4
age[age.cat == "18-29"] <- 1
age[age.cat == "30-49"] <- 2
age[age.cat == "50-65"] <- 3
age[age.cat == "65+"] <- 4
age <- factor(age, levels = 1:4, labels = c("18-29", "30-44", "45-64", "65+"))
table(age)
rm(age.years); rm(age.cat)

# sex 
sex <- jun13$QD1
table(sex)

# education
education <- jun13$QD11
table(education)
levels(education)[levels(education)=="Less than high school (Grades 1-8 or no formal schooling)"] <- "less than a high school education"
levels(education)[levels(education)=="High school incomplete (Grades 9-11 or Grade 12 with NO diploma)"] <- "less than a high school education"
levels(education)[levels(education)=="High school graduate (Grade 12 with diploma or GED certificate)"] <- "high school graduate"
levels(education)[levels(education)=="Some college, no degree (includes some community college)"] <- "some college"
levels(education)[levels(education)=="Two year associate degree from a college or university"] <- "some college"
levels(education)[levels(education)=="Four year college or university degree/Bachelor's degree (e.g., BS, BA, AB)"] <- "college graduate"
levels(education)[levels(education)=="Some postgraduate or professional schooling, no postgraduate degree"] <- "college graduate"
levels(education)[levels(education)=="Postgraduate or professional degree, including master's, doctorate, medical or law degree (e.g., MA, MS, PhD, MD, JD)"] <- "postgraduate"
education[education == "Don't know/Refused (VOL.)"] <- NA
education <- factor(education)
table(education)

# interactions
sex.race <- interaction(sex, race)

# combine variables
jun13.data <- data.frame(aca.fav, state, race, income, sex, sex.race, age, education)
jun13.data <- na.omit(jun13.data)
jun13.data$month <- "June"; jun13.data$month <- factor(jun13.data$month)
jun13.data$t <- 6
rm(aca.fav, state, race, income, sex, sex.race, age, education)

################################################################################
## July 2013
################################################################################

# state
state <- as.character(jul13$STATE)
table(state)
temp <- unique(state)
for (i in 1:length(temp)) {
  print(temp[i])
  state[state == temp[i]] <- state.names$abbr[state.names$full == temp[i]]
}
rm(temp)
table(state)

# aca favorability
aca.fav <- jul13$Q1
table(aca.fav)
aca.fav <- as.numeric(aca.fav)
table(as.numeric(aca.fav))
aca.fav[aca.fav == 5] <- NA
aca.fav <- 1*(aca.fav <= 2)
table(aca.fav)

# race
race <- jul13$RACETHN
table(race)
levels(race)[levels(race)=="White~Hisp"] <- "White"
levels(race)[levels(race)=="AA~Hisp"] <- "Black"
levels(race)[levels(race)=="Hispanic"] <- "Hispanic"
levels(race)[levels(race)=="Other~Hisp"] <- "Other"
race[race=="DK/Ref"] <- NA
race <- factor(race)
table(race)

# income
income <- jul13$QD14
table(income)
levels(income)[levels(income)=="Less than $20,000"] <- "less than $20,000"
levels(income)[levels(income)=="$20,000 to less than $30,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$30,000 to less than $40,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$40,000 to less than $50,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$50,000 to less than $75,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$75,000 to less than $90,000"] <- "$75,000+"
levels(income)[levels(income)=="$90,000 to less than $100,000"] <- "$75,000+"
levels(income)[levels(income)=="$100,000 or more"] <- "$75,000+"
income[income == "(DO NOT READ) Don't know/Refused"] <- NA
income <- factor(income)
table(income)

# age
age.years <- jul13$QD5
summary(age.years)
age.cat <- jul13$QD6
table(age.cat)
age <- rep(NA, length(age.years))
age[age.years >= 18 & age.years <= 29] <- 1
age[age.years >= 30 & age.years <= 44] <- 2
age[age.years >= 45 & age.years <= 64] <- 3
age[age.years >= 65 & age.years < 99] <- 4
age[age.cat == "18-29"] <- 1
age[age.cat == "30-49"] <- 2
age[age.cat == "50-65"] <- 3
age[age.cat == "65+"] <- 4
age <- factor(age, levels = 1:4, labels = c("18-29", "30-44", "45-64", "65+"))
table(age)
rm(age.years); rm(age.cat)

# sex 
sex <- jul13$QD1
table(sex)

# education
education <- jul13$QD11
table(education)
levels(education)[levels(education)=="Less than high school (Grades 1-8 or no formal schooling)"] <- "less than a high school education"
levels(education)[levels(education)=="High school incomplete (Grades 9-11 or Grade 12 with NO diploma)"] <- "less than a high school education"
levels(education)[levels(education)=="High school graduate (Grade 12 with diploma or GED certificate)"] <- "high school graduate"
levels(education)[levels(education)=="Some college, no degree (includes some community college)"] <- "some college"
levels(education)[levels(education)=="Two year associate degree from a college or university"] <- "some college"
levels(education)[levels(education)=="Four year college or university degree/Bachelor's degree (e.g., BS, BA, AB)"] <- "college graduate"
levels(education)[levels(education)=="Some postgraduate or professional schooling, no postgraduate degree"] <- "college graduate"
levels(education)[levels(education)=="Postgraduate or professional degree, including master's, doctorate, medical or law degree (e.g., MA, MS, PhD, MD, JD)"] <- "postgraduate"
education[education == "Don't know/Refused (VOL.)"] <- NA
education <- factor(education)
table(education)

# interactions
sex.race <- interaction(sex, race)

# combine variables
jul13.data <- data.frame(aca.fav, state, race, income, sex, sex.race, age, education)
jul13.data <- na.omit(jul13.data)
jul13.data$month <- "July"; jul13.data$month <- factor(jul13.data$month)
jul13.data$t <- 7
rm(aca.fav, state, race, income, sex, sex.race, age, education)

################################################################################
## August 2013
################################################################################

# state
state <- as.character(aug13$STATE)
table(state)
temp <- unique(state)
for (i in 1:length(temp)) {
  print(temp[i])
  state[state == temp[i]] <- state.names$abbr[state.names$full == temp[i]]
}
rm(temp)
table(state)

# aca favorability
aca.fav <- aug13$Q1
table(aca.fav)
aca.fav <- as.numeric(aca.fav)
table(as.numeric(aca.fav))
aca.fav[aca.fav == 5] <- NA
aca.fav <- 1*(aca.fav <= 2)
table(aca.fav)

# race
race <- aug13$RACETHN
table(race)
levels(race)[levels(race)=="White~Hisp"] <- "White"
levels(race)[levels(race)=="AA~Hisp"] <- "Black"
levels(race)[levels(race)=="Hispanic"] <- "Hispanic"
levels(race)[levels(race)=="Other~Hisp"] <- "Other"
race[race=="DK/Ref"] <- NA
race <- factor(race)
table(race)

# income
income <- aug13$QD14
table(income)
levels(income)[levels(income)=="Less than $20,000"] <- "less than $20,000"
levels(income)[levels(income)=="$20,000 to less than $30,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$30,000 to less than $40,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$40,000 to less than $50,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$50,000 to less than $75,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$75,000 to less than $90,000"] <- "$75,000+"
levels(income)[levels(income)=="$90,000 to less than $100,000"] <- "$75,000+"
levels(income)[levels(income)=="$100,000 or more"] <- "$75,000+"
income[income == "(DO NOT READ) Don't know/Refused"] <- NA
income <- factor(income)
table(income)

# age
age.years <- aug13$QD5
summary(age.years)
age.cat <- aug13$QD6
table(age.cat)
age <- rep(NA, length(age.years))
age[age.years >= 18 & age.years <= 29] <- 1
age[age.years >= 30 & age.years <= 44] <- 2
age[age.years >= 45 & age.years <= 64] <- 3
age[age.years >= 65 & age.years < 99] <- 4
age[age.cat == "18-29"] <- 1
age[age.cat == "30-49"] <- 2
age[age.cat == "50-65"] <- 3
age[age.cat == "65+"] <- 4
age <- factor(age, levels = 1:4, labels = c("18-29", "30-44", "45-64", "65+"))
table(age)
rm(age.years); rm(age.cat)

# sex 
sex <- aug13$QD1
table(sex)

# education
education <- aug13$QD11
table(education)
levels(education)[levels(education)=="Less than high school (Grades 1-8 or no formal schooling)"] <- "less than a high school education"
levels(education)[levels(education)=="High school incomplete (Grades 9-11 or Grade 12 with NO diploma)"] <- "less than a high school education"
levels(education)[levels(education)=="High school graduate (Grade 12 with diploma or GED certificate)"] <- "high school graduate"
levels(education)[levels(education)=="Some college, no degree (includes some community college)"] <- "some college"
levels(education)[levels(education)=="Two year associate degree from a college or university"] <- "some college"
levels(education)[levels(education)=="Four year college or university degree/Bachelor's degree (e.g., BS, BA, AB)"] <- "college graduate"
levels(education)[levels(education)=="Some postgraduate or professional schooling, no postgraduate degree"] <- "college graduate"
levels(education)[levels(education)=="Postgraduate or professional degree, including master's, doctorate, medical or law degree (e.g., MA, MS, PhD, MD, JD)"] <- "postgraduate"
education[education == "Don't know/Refused (VOL.)"] <- NA
education <- factor(education)
table(education)

# interactions
sex.race <- interaction(sex, race)

# combine variables
aug13.data <- data.frame(aca.fav, state, race, income, sex, sex.race, age, education)
aug13.data <- na.omit(aug13.data)
aug13.data$month <- "August"; aug13.data$month <- factor(aug13.data$month)
aug13.data$t <- 8
rm(aca.fav, state, race, income, sex, sex.race, age, education)

################################################################################
## September 2013
################################################################################

# state
state <- as.character(sep13$STATE)
table(state)
temp <- unique(state)
for (i in 1:length(temp)) {
  print(temp[i])
  state[state == temp[i]] <- state.names$abbr[state.names$full == temp[i]]
}
rm(temp)
table(state)

# aca favorability
aca.fav <- sep13$Q1
aca.fav <- as.numeric(aca.fav)
aca.fav[aca.fav == 5] <- NA
aca.fav <- 1*(aca.fav <= 2)
table(aca.fav)

# race
race <- sep13$RACETHN
levels(race)[levels(race)=="White~Hisp"] <- "White"
levels(race)[levels(race)=="AA~Hisp"] <- "Black"
levels(race)[levels(race)=="Hispanic"] <- "Hispanic"
levels(race)[levels(race)=="Other~Hisp"] <- "Other"
race[race=="DK/Ref"] <- NA
race <- factor(race)
table(race)

# income
income <- sep13$QD14
levels(income)[levels(income)=="Less than $20,000"] <- "less than $20,000"
levels(income)[levels(income)=="$20,000 to less than $30,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$30,000 to less than $40,000"] <- "$20,000-$40,000"
levels(income)[levels(income)=="$40,000 to less than $50,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$50,000 to less than $75,000"] <- "$40,000-$75,000"
levels(income)[levels(income)=="$75,000 to less than $90,000"] <- "$75,000+"
levels(income)[levels(income)=="$90,000 to less than $100,000"] <- "$75,000+"
levels(income)[levels(income)=="$100,000 or more"] <- "$75,000+"
income[income == "(DO NOT READ) Don't know/Refused"] <- NA
income <- factor(income)

# age
age.years <- sep13$QD5
age.cat <- sep13$QD6
age <- rep(NA, length(age.years))
age[age.years >= 18 & age.years <= 29] <- 1
age[age.years >= 30 & age.years <= 44] <- 2
age[age.years >= 45 & age.years <= 64] <- 3
age[age.years >= 65 & age.years < 99] <- 4
age[age.cat == "18-29"] <- 1
age[age.cat == "30-49"] <- 2
age[age.cat == "50-65"] <- 3
age[age.cat == "65+"] <- 4
age <- factor(age, levels = 1:4, labels = c("18-29", "30-44", "45-64", "65+"))
table(age)
rm(age.years); rm(age.cat)

# sex 
sex <- sep13$QD1
table(sex)

# education
education <- sep13$QD11
table(education)
levels(education)[levels(education)=="Less than high school (Grades 1-8 or no formal schooling)"] <- "less than a high school education"
levels(education)[levels(education)=="High school incomplete (Grades 9-11 or Grade 12 with NO diploma)"] <- "less than a high school education"
levels(education)[levels(education)=="High school graduate (Grade 12 with diploma or GED certificate)"] <- "high school graduate"
levels(education)[levels(education)=="Some college, no degree (includes some community college)"] <- "some college"
levels(education)[levels(education)=="Two year associate degree from a college or university"] <- "some college"
levels(education)[levels(education)=="Four year college or university degree/Bachelor's degree (e.g., BS, BA, AB)"] <- "college graduate"
levels(education)[levels(education)=="Some postgraduate or professional schooling, no postgraduate degree"] <- "college graduate"
levels(education)[levels(education)=="Postgraduate or professional degree, including master's, doctorate, medical or law degree (e.g., MA, MS, PhD, MD, JD)"] <- "postgraduate"
education[education == "Don't know/Refused (VOL.)"] <- NA
education <- factor(education)
table(education)
# interactions
sex.race <- interaction(sex, race)

# combine variables
sep13.data <- data.frame(aca.fav, state, race, income, sex, sex.race, age, education)
sep13.data <- na.omit(sep13.data)
sep13.data$month <- "September"; sep13.data$month <- factor(sep13.data$month)
sep13.data$t <- 9
rm(aca.fav, state, race, income, sex, sex.race, age, education)

################################################################################
## Combine the Polling Data
################################################################################

poll.data <- rbind(sep13.data, aug13.data, jul13.data, jun13.data, may13.data)

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

# multiple regression with post-stratification
# mrp.est.sep13 <- mrp(aca.fav ~ state + race + sex + sex.race,
#                data=sep13.data,
#                population=mrp.census,
#                pop.weights="weighted2008",
#                grouplevel.data.frames = list(obama2008, obama2012),
#                formula.model.update = .~.+obama_share_12
# )
# mrp.est.aug13 <- mrp(aca.fav ~ state + race + sex + sex.race,
#                 data=aug13.data,
#                 population=mrp.census,
#                 pop.weights="weighted2008",
#                 grouplevel.data.frames = list(obama2008, obama2012),
#                 formula.model.update = .~.+obama_share_12
# )
# mrp.est.jul13 <- mrp(aca.fav ~ state + race + sex + sex.race,
#                      data=jul13.data,
#                      population=mrp.census,
#                      pop.weights="weighted2008",
#                      grouplevel.data.frames = list(obama2008, obama2012),
#                      formula.model.update = .~.+obama_share_12
# )
# mrp.est.jun13 <- mrp(aca.fav ~ state, #+ race + sex + sex.race,
#                      data=jun13.data,
#                      population=mrp.census,
#                      pop.weights="weighted2008",
#                      grouplevel.data.frames = list(obama2008, obama2012),
#                      formula.model.update = .~.+obama_share_12
# )
# mrp.est.may13 <- mrp(aca.fav ~ state, #+ race + sex + sex.race,
#                      data=may13.data,
#                      population=mrp.census,
#                      pop.weights="weighted2008",
#                      grouplevel.data.frames = list(obama2008, obama2012),
#                      formula.model.update = .~.+obama_share_12
# )

mrp.est0 <- mrp(aca.fav ~ state,
               data=poll.data,
               population=mrp.census,
               pop.weights="weighted2008",
               grouplevel.data.frames = list(obama2008, obama2012),
               formula.model.update = .~. + obama_share_12,
)

mrp.est <- mrp(aca.fav ~ state + race + sex + sex.race + income + age,
               data=poll.data,
               population=mrp.census,
               pop.weights="weighted2008",
               grouplevel.data.frames = list(obama2008, obama2012),
               formula.model.update = .~.+ obama_share_12,
)

print(AIC(slot(mrp.est0, "multilevelModel")))
print(AIC(slot(mrp.est, "multilevelModel")))

# mrp.est <- mrp(aca.fav ~ state + race + sex + sex.race + income + age + education,
#            data=poll.data,
#            population=mrp.census,
#            pop.weights="weighted2008",
#            grouplevel.data.frames = list(obama2008, obama2012, health, region),
#                formula.model.update = .~.+ obama_share_12 + (1|region)
# )

ps <- poststratify(mrp.est, ~ state)
ps0 <- poststratify(mrp.est0, ~ state)
eplot(xlim = c(0, 1), ylim = c(0, 52), anny = FALSE)
abline(v = .5)
abline(h = 1:51, lty = 3, col = "grey70")
points(ps[order(ps)], 1:51, pch = 19)
points(ps0[order(ps)], 1:51, pch = 4, col = "red")
text(ps[order(ps)], 1:51, names(ps[order(ps)]), pos = 4, cex = .5)

# print(AIC(slot(mrp.est0, "multilevelModel")))
# print(AIC(slot(mrp.est, "multilevelModel")))
# display((slot(mrp.est, "multilevelModel")))
# 

mrp.data <- data.frame(ps0, names(ps0), row.names = 1:length(ps))
colnames(mrp.data) <- c("percent_favorable_aca", "state_abbr")
write.csv(mrp.data, "Data/mrp_est.csv", row.names = FALSE)
