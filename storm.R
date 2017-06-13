##############################################################################
## File: storm.R
##
## Description: Course_Project 2: Reproducible Research
## https://www.coursera.org/learn/reproducible-research/peer/OMZ37/course-project-2
##
##
## Author: Pedro A. Alonso Baigorri
##############################################################################



# setting the working path
setwd("D://GIT_REPOSITORY//Rep_Data_Practice_2")


# Load required libraries
library(dplyr)
library(stringr)
library(ggplot2)
library(R.utils)


# Getting the data
fileURL <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
localFile <- "./data/storm.zip"
destFile <- "./data/storm.csv"


if (!file.exists(localFile))
{
    if (!file.exists("./data")){dir.create("./data")}
    
    download.file(fileURL, localFile)
    bunzip2(localFile, destFile, remove = FALSE )
}

storms <- read.csv(destFile)

dim(storms)
str(storms)

# filtering data before of jan 1996
head(storms$BGN_DATE)
storms$date <- as.Date(storms$BGN_DATE, "%m/%d/%Y")
head(storms$date)
storms <- subset(storms, date > as.Date("12/31/1995", "%m/%d/%Y"))
dim(storms)
min(storms$date)

#selecting only the columns of interest
myvars <- c("EVTYPE", "FATALITIES", "INJURIES", 
             "PROPDMG", "PROPDMGEXP", "CROPDMG",
             "CROPDMGEXP")
storms <- subset(storms, select = myvars)
colnames(storms) <- myvars

dim(storms)

# fixing the typos of event type column
length(unique(storms$EVTYPE))

# transforming to uppercase
storms$EVTYPE <- toupper(storms$EVTYPE)
length(unique(storms$EVTYPE))

#removing starting white spaces
storms$EVTYPE <- trimws(storms$EVTYPE)
length(unique(storms$EVTYPE))

# setting the right value to damage variables

levels(storms$PROPDMGEXP)

#symbols are multipler of 0 except + that is 1
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == ""] <- 0
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "-"] <- 0
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "?"] <- 0
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "+"] <- 1

# numbers from 0-9 are multiplier of 10 according to coursera forum article
# https://rstudio-pubs-static.s3.amazonaws.com/58957_37b6723ee52b455990e149edde45e5b6.html
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "0"] <- 10
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "1"] <- 10
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "2"] <- 10
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "3"] <- 10
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "4"] <- 10
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "5"] <- 10
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "6"] <- 10
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "7"] <- 10
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "8"] <- 10
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "9"] <- 10

#then standard currency symbols
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "B"] <- 1000000000
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "h"] <- 100
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "H"] <- 100
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "K"] <- 1000
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "m"] <- 1000
storms$PROPDMGEXP_VALUE[storms$PROPDMGEXP == "M"] <- 1000

storms$PROPDMGEXP_VALUE <- storms$PROPDMGEXP_VALUE * storms$PROPDMG

#and now for CROPS
levels(storms$CROPDMGEXP)

storms$CROPDMGEXP_VALUE[storms$CROPDMGEXP == ""] <- 0
storms$CROPDMGEXP_VALUE[storms$CROPDMGEXP == "?"] <- 0
storms$CROPDMGEXP_VALUE[storms$CROPDMGEXP == "0"] <- 10
storms$CROPDMGEXP_VALUE[storms$CROPDMGEXP == "2"] <- 10
storms$CROPDMGEXP_VALUE[storms$CROPDMGEXP == "B"] <- 1000000000
storms$CROPDMGEXP_VALUE[storms$CROPDMGEXP == "k"] <- 1000
storms$CROPDMGEXP_VALUE[storms$CROPDMGEXP == "K"] <- 1000
storms$CROPDMGEXP_VALUE[storms$CROPDMGEXP == "m"] <- 1000
storms$CROPDMGEXP_VALUE[storms$CROPDMGEXP == "M"] <- 1000

storms$CROPDMGEXP_VALUE <- storms$CROPDMGEXP_VALUE * storms$CROPDMG

head(storms)

