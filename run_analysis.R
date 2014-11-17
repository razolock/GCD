## The purpose of this script is to satisfy the course project requirement
## for Getting and Cleaning Data

## First, merge the training and the test sets to create one data set.

## I'll use two packages for this work
library(tidyr)
library(dplyr)

### read the "X_test.txt" data into a dataframe.  R does this in 561 variables
### set the working directory to the folder with the 'test' files
setwd("~/Documents/R/GCD/UCI HAR Dataset/test")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt", col.names = "activity_number",
                     colClasses = "numeric")
subject_test <- read.table("subject_test.txt")

### reading in the label name files (in difference directory)
setwd("~/Documents/R/GCD/UCI HAR Dataset")
activity_labels <- read.table(file = "activity_labels.txt",
                              col.names = c("activity_number", "activity_name"),
                              colClasses = c("numeric", "character"))

feature_labels <- read.table(file = "features.txt",
                              col.names = c("feature_number", "feature_name"),
                              colClasses = c("numeric", "character"))

### rename the column labels in x_test to the feature labels
colnames(x_test) <- feature_labels[, 2]

### Add a column to y_test with the corresponding activity names
### create a new data frame y_test2
y_test2 <- inner_join(y_test, activity_labels, by = "activity_number")




### the inertial signals are in a separate folder
setwd("~/Documents/R/GCD/UCI HAR Dataset/test/Inertial Signals")
### reading in the intertial values
### start with the estimated body acceleration
body_acc_x_test <- read.table("body_acc_x_test.txt")