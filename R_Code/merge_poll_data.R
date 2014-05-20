# clear workspace
rm(list = ls())

# set working directory
setwd("~/Dropbox/Projects/ACA_Opinion")

# load polls
kaiser.2012.01 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_01.csv")
kaiser.2012.02 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_02.csv")
kaiser.2012.03 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_03.csv")
kaiser.2012.04 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_04.csv")
kaiser.2012.05 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_05.csv")
kaiser.2012.06 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_06.csv")
kaiser.2012.07 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_07.csv")
kaiser.2012.08 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_08.csv")
kaiser.2012.09 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_09.csv")
kaiser.2012.10 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_10.csv")
kaiser.2012.11 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2012_11.csv")
kaiser.2013.02 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2013_02.csv")
kaiser.2013.03 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2013_03.csv")
kaiser.2013.04 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2013_04.csv")
kaiser.2013.06 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2013_06.csv")
kaiser.2013.08 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2013_08.csv")
kaiser.2013.09 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2013_09.csv")
kaiser.2013.10 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2013_10.csv")
kaiser.2013.11 <- read.csv("Data/Cleaned_Poll_Data/kaiser_2013_11.csv")

d <- rbind(kaiser.2012.01,
           kaiser.2012.02,
           kaiser.2012.03,
           kaiser.2012.04,
           kaiser.2012.05,
           kaiser.2012.06,
           kaiser.2012.07,
           kaiser.2012.08,
           kaiser.2012.09,
           kaiser.2012.10,
           kaiser.2012.11,
           kaiser.2013.02,
           kaiser.2013.03,
           kaiser.2013.04,
           kaiser.2013.06,
           kaiser.2013.08,
           kaiser.2013.09,
           kaiser.2013.10,
           kaiser.2013.11)
summary(d)

write.csv(d, "Data/poll_data.csv", row.names = FALSE)
