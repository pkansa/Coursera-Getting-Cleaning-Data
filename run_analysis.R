## check if the data directory exists; if not, create it
if (!file.exists("data")) {
        dir.create("data")
}

## set the url of the file to download
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## and download it to the data directory in the working directory
download.file(fileURL, destfile = "./data/dataset.zip")

## unzip the file into the data directory
unzip("./data/dataset.zip", exdir = "./data")

## change the working directory to what was unzipped
setwd("./data/UCI HAR Dataset")

## read in the test files
subject_test <- read.table("./test/subject_test.txt") ## this identifies the subject who performed the activity
x_test <- read.table("./test/X_test.txt") ## this is the test set
y_test <- read.table("./test/y_test.txt") ## these are the test set labels

## read in the training files
subject_train <- read.table("./train/subject_train.txt")
x_train <- read.table("./train/X_train.txt")  ## this is the training set
y_train <- read.table("./train/y_train.txt")  ## these are the training set labels

## Load activity labels + features from the data
activityLabels <- read.table("./activity_labels.txt")   ## this identifies the subject who performed the activity
activityLabels[,2] <- as.character(activityLabels[,2])  ## need to convert the column to text
features <- read.table("./features.txt")                ## list of all the features
features[,2] <- as.character(features[,2])              ## need to convert the column to text

## Combine the x data (training + test)
x_data <- rbind(x_train, x_test)

## Combine the y data (training labels + test labels)
y_data <- rbind(y_train, y_test)

## Combine the subject data
subject_data <- rbind(subject_train, subject_test)


## Identify the features that have a mean or standard deviation identified
FeaturesNeeded <- grep("-(mean|std)\\(\\)", features[, 2]) ## identify the positions

## subset just the columns that we want
x_data_sub <- x_data[, FeaturesNeeded]

## and then correct the column names
names(x_data_sub) <- features[FeaturesNeeded, 2]
## let's do some further scrubbing of the names to get rid of hyphens and parentheses, and get readable labels
names(x_data_sub) <- gsub('-mean', 'Mean', names(x_data_sub))  ## change out the name
names(x_data_sub) <- gsub('-std', 'StandardDeviation', names(x_data_sub))    ## change out the name
names(x_data_sub) <- gsub('[-()]', '', names(x_data_sub))  ## remove parentheses

## the friendlier descriptions for this step were derived from features_info.txt
names(x_data_sub) <- gsub('Acc',"Acceleration",names(x_data_sub))
names(x_data_sub) <- gsub('Mag',"Magnitude",names(x_data_sub))
names(x_data_sub) <- gsub('Gyro',"AngularVelocity",names(x_data_sub))
names(x_data_sub) <- gsub('^t',"TimeDomain",names(x_data_sub))
names(x_data_sub) <- gsub('^f',"FrequencyDomain",names(x_data_sub))

## now we need to correct the column values for the activities
y_data[, 1] <- activityLabels[y_data[, 1], 2]

## as well as the column name itself
names(y_data) <- "activity"

## correct the column name for the subject_data
names(subject_data) <- "subject"

## now that we've cleaned up the labelling, it's time to combine everything together
combined_data <- cbind(x_data_sub, y_data, subject_data)

## Now, it's time to create the tidy dataset
library(plyr);

## use the aggregate function to easily compute the average for each variable for subject and activity
tidydata<-aggregate(. ~subject + activity, combined_data, mean)
## and then sort it by subject and activity
tidydata <- tidydata[order(tidydata$subject,tidydata$activity),]

## last, but not least, we need to write the data back out
## back things up to the higher-level directory
setwd("../")
write.table(tidydata, file = "tidydata.txt",row.name=FALSE)
