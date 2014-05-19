# clear workspace
rm(list = ls())

# set working directory
setwd("~/Dropbox/Projects/ACA_Opinion")

# load packages
library(foreign)

# load data
d <- read.spss("Data/Kaiser/kaiser_2013_09.por")
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
aca.fav <- d$Q1
aca.fav <- as.numeric(aca.fav)
aca.fav[aca.fav == 5] <- NA
aca.fav <- 1*(aca.fav <= 2)
table(aca.fav)

# race
race <- d$RACETHN
levels(race)[levels(race)=="White~Hisp"] <- "White"
levels(race)[levels(race)=="AA~Hisp"] <- "Black"
levels(race)[levels(race)=="Hispanic"] <- "Hispanic"
levels(race)[levels(race)=="Other~Hisp"] <- "Other"
race[race=="DK/Ref"] <- NA
race <- factor(race)
table(race)

# income
income <- d$QD14
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
age.years <- d$QD5
age.cat <- d$QD6
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
sex <- d$QD1
table(sex)

# education
education <- d$QD11
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
new.data <- data.frame(aca.fav, state, race, income, sex, sex.race, age, education)
new.data <- na.omit(new.data)

# survey-level variables
new.data$month <- factor("September")
new.data$polling.org <- factor("Kaiser")

# write csv file
write.csv(new.data, "Data/Cleaned_Poll_Data/kaiser_2013_09.csv", row.names = FALSE)

summary(new.data)