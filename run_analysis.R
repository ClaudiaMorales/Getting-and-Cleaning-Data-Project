## Here are the data for the project:
    ## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## Create one R script called run_analysis.R 

## Reading data into R 
setwd("C:/Users/vgw52064/Desktop/Coursera/")
library(data.table)   ## efficient in handling large datasets
library(plyr)
library(dplyr)        ## used to aggregate variables to create tidy data

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="GCDdataset.zip")

## to unzip the file and put it in the currect directory under GCDProject
unzip(zipfile="GCDdataset.zip",exdir="GCDProject")

## now I need to get the list of files
path_rf <- file.path("GCDProject" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

## Read data from files into the variables
## Train Data
subjectTrain <- read.table("GCDProject/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("GCDProject/UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("GCDProject/UCI HAR Dataset/train/X_train.txt", header = FALSE)

## Test Data
subjectTest <- read.table("GCDProject/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("GCDProject/UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("GCDProject/UCI HAR Dataset/test/X_test.txt", header = FALSE)

## Properties of the variables above 
str(activityTest)
str(activityTrain)
str(subjectTest)
str(subjectTrain)
str(featuresTest)
str(featuresTrain)

#################################     1. Merge the training and the test sets to create one data set   ##################################
## Concatenate the data tables by rows
Subject <- rbind(subjectTest, subjectTrain)
Activity <- rbind(activityTest, activityTrain)
Features <- rbind(featuresTest, featuresTrain)

## Name variables
names(Subject) <-c("subject")
names(Activity) <- c("activity")
FeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Features) <- FeaturesNames$V2

## Merge the columns for all data into "Data"
Data <- cbind(Features,Activity,Subject)

#################################     2. Extract only the mean and std deviation for each measurement   ##################################
## Extract the column indices that have either mean or std in them.
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(Data), ignore.case=TRUE)

## Add activity and subject columns to the list and look at the dimension of Data
requiredColumns <- c(columnsWithMeanSTD, 562,563)
dim(Data)

## We create extractedData with the selected columns in requiredColumns. And again, we look at the dimension of requiredColumns
extractedData <- Data[,requiredColumns]
dim(extractedData)


#################################     3. Use descriptive activity names to name the activities in the dataset   ##################################
## Read descriptive activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
## The activity field in extractedData is originally of numeric type. 
## We need to change its type to character so that it can accept activity names. 
## The activity names are taken from metadata activityLabels.
extractedData$activity <- as.character(extractedData$activity)
for (i in 1:6){
    extractedData$activity[extractedData$activity == i] <- as.character(activityLabels[i,2])
}
head(extractedData$activity,30)


#################################     4. Appropriately labels the data set with descriptive variable names   ##################################
## First examine the data names  
names(extractedData)


## names to make sense:
names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))
names(extractedData)

##########     5. From dataset above, create a tidy data set w the avg of each variable for each activity and each subject   #######################
## We create tidyData as a data set with average for each activity and subject
tidyData <- aggregate(. ~subject + activity, extractedData, mean)
## Now order entries in tidyData and write it into data file Tidy.txt that contains the processed data
tidyData <- tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
