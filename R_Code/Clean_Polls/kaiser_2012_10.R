# clear workspace
rm(list = ls())

# set working directory
setwd("~/Dropbox/Projects/ACA_Opinion")

# load packages
library(foreign)

# load data
d <- read.spss("Data/Kaiser/kaiser_2012_10.por")
state.names <- read.csv("Data/Aggregate_Data/state_names.csv", stringsAsFactors = FALSE)

# state
state <- as.character(d$STATE)
table(state)
temp <- unique(state)
for (i in 1:length(temp)) {
  state[state == temp[i]] <- state.names$abbr[state.names$full == temp[i]]
}
rm(temp)
table(state)

# aca favorability
aca.fav <- d$Q3
table(aca.fav)
aca.fav <- as.numeric(aca.fav)
aca.fav[aca.fav == 5] <- NA
aca.fav <- 1*(aca.fav <= 2)
table(aca.fav)

# race
race <- d$RACETHN
table(race)
levels(race)[levels(race)=="White~Hisp"] <- "White"
levels(race)[levels(race)=="AA~Hisp"] <- "Black"
levels(race)[levels(race)=="Hispanic"] <- "Hispanic"
levels(race)[levels(race)=="Other~Hisp"] <- "Other"
race[race=="DK/Ref"] <- NA
race <- factor(race)
table(race)

# income
income <- d$QD14
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
age.years <- d$QD5
summary(age.years)
age.cat <- d$QD6
table(age.cat)
age <- rep(NA, length(age.years))
age[age.years >= 18 & age.years <= 29] <- 1
age[age.years >= 30 & age.years <= 44] <- 2
age[age.years >= 45 & age.years <= 64] <- 3
age[age.years >= 65 & age.years < 99] <- 4
age[age.cat == "18-29"] <- 1
age[age.cat == "30-49"] <- 2
age[age.cat == "50-64"] <- 3
age[age.cat == "65+"] <- 4
age <- factor(age, levels = 1:4, labels = c("18-29", "30-44", "45-64", "65+"))
table(age)
rm(age.years); rm(age.cat)

# sex 
sex <- d$QD1
table(sex)

# education
education <- d$QD11
table(education)
levels(education)[levels(education)=="None, or grade 1-8"] <- "less than a high school education"
levels(education)[levels(education)=="High school incomplete (grades 9-11)"] <- "less than a high school education"
levels(education)[levels(education)=="High school graduate (grade 12 or GED certificate)"] <- "high school graduate"
levels(education)[levels(education)=="Technical, trade or vocational school AFTER high school"] <- "some college"
levels(education)[levels(education)=="Some college, no four-year degree (includes associate degree)"] <- "some college"
levels(education)[levels(education)=="College graduate (B.S., B.A., or other four-year degree)"] <- "college graduate"
levels(education)[levels(education)=="Some postgraduate or professional schooling, no postgraduate degree"] <- "college graduate"
levels(education)[levels(education)=="Post-graduate or professional schooling after college"] <- "postgraduate"
education[education == "(DO NOT READ) Don't know/Refused"] <- NA
education <- factor(education)
table(education)
# Note: there is no indication in this survey of whether the respondent earned a postgraduate degree
# In this case, I've coded the respondents who reported some postgraduate education as having a postgraduate degree.

# interactions
sex.race <- interaction(sex, race)

# combine variables
new.data <- data.frame(aca.fav, state, race, income, sex, sex.race, age, education)
new.data <- na.omit(new.data)

# survey-level variables
new.data$month <- factor("October")
new.data$year <- factor("2012")
new.data$polling.org <- factor("Kaiser")

# write csv file
write.csv(new.data, "Data/Cleaned_Poll_Data/kaiser_2012_10.csv", row.names = FALSE)

summary(new.data)