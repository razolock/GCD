## The purpose of this script is to satisfy the course project requirement
## for Getting and Cleaning Data

## code to run this from the command line
# setwd("~/Documents/R/GCD")
# source("run_analysis.r")

## First, merge the training and the test sets to create one data set.

# test data set

## I'll use two packages for this work
library(tidyr)
library(dplyr)

## read the "X_test.txt" data into a dataframe.  R does this in 561 variables
## set the working directory to the folder with the 'test' files
setwd("~/Documents/R/GCD/UCI HAR Dataset/test")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt", col.names = "activity_number",
                     colClasses = "numeric")
subject_test <- read.table("subject_test.txt")

## reading in the label name files (in different directory)
setwd("~/Documents/R/GCD/UCI HAR Dataset")
feature_labels <- read.table(file = "features.txt",
                             col.names = c("feature_number", "feature_name"),
                             colClasses = c("numeric", "character"))
activity_labels <- read.table(file = "activity_labels.txt",
                              col.names = c("activity_number", "activity_name"),
                              colClasses = c("numeric", "character"))

## rename the column labels in x_test to the feature labels
colnames(x_test) <- feature_labels[, 2]

## rename the column labels in subject_test to subject
colnames(subject_test) <- "subject"

## Add a column to y_test with the corresponding activity names
## create a new data frame y_test2
y_test2 <- inner_join(y_test, activity_labels, by = "activity_number")

## combine all data into a single data frame df
df_test <- cbind(subject_test, y_test2, x_test)
df_test$type <- "test"

# train

## set the working directory
setwd("~/Documents/R/GCD/UCI HAR Dataset/train")

## read in the train files
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt", col.names = "activity_number",
                     colClasses = "numeric")
subject_train <- read.table("subject_train.txt")

## rename the column labels in x_test to the feature labels
colnames(x_train) <- feature_labels[, 2]

## rename the column labels in subject_test to subject
colnames(subject_train) <- "subject"

## Add a column to y_test with the corresponding activity names
## create a new data frame y_test2
y_train2 <- inner_join(y_train, activity_labels, by = "activity_number")

## combine all data into a single data frame df
df_train <- cbind(subject_train, y_train2, x_train)
df_train$type <- "train"

# combine the df_test and df_train into a single data frame
df <- rbind(df_test, df_train)

# extract only the columns that include the calculation of a mean or 
# standard deviation
df_columnNames <- colnames(df)
# the set of columns containing mean is...
mean_columnNames <- df_columnNames[grep("mean", df_columnNames)]
# the set of columns containing "std" is...
std_columnNames <- df_columnNames[grep("std", df_columnNames)]
# the combined set of column names, inclusive of identifying information...
extract_columnNames <- c("subject", "activity_number", "activity_name",
                         "type", mean_columnNames, std_columnNames)

# Finally the extracted data set...
df_extract <- df[, extract_columnNames]

# export the file to *.txt format
setwd("~/Documents/R/GCD")
write.table(df_extract, file= "df_extract.txt", row.name=FALSE)

# From the df_extract data set, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

## create subsets by activity and subject using `filter`
df_bySubject <- aggregate(df_extract[5:83], by=list(df_extract$subject), FUN=mean)
colnames(df_bySubject)[1] <- "subject"
df_byActivity <- aggregate(df_extract[5:83], by=list(df_extract$activity_name), FUN=mean)
colnames(df_byActivity)[1] <- "activity_name"
df_bySubject$activity_name <- "all"
df_byActivity$subject <- "all"

## create the new data set using `rbind`
df_extract2 <- rbind(df_byActivity, df_bySubject)

# export the file to *.txt format
write.table(df_extract2, file= "df_extract2.txt", row.name=FALSE)