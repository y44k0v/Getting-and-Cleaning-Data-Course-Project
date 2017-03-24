library(plyr)
library(reshape2)

## Gathering the data 
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,"w4.zip", method = "curl")
unzip("w4.zip")

## Reading activity labels, features, test and training data

activityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt")

features<-read.table("./UCI HAR Dataset/features.txt")

xTest<-read.table("./UCI HAR Dataset/test/X_test.txt")
yTest<-read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest<-read.table("./UCI HAR Dataset/test/subject_test.txt")

xTrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain<-read.table("./UCI HAR Dataset/train/subject_train.txt")

## Consolidating Data 

xData<-rbind(xTest, xTrain)
yData<-rbind(yTest, yTrain)
subject<-rbind(subjectTest, subjectTrain)

## Selecting measurements on the mean and standard deviation 

# Assigning features to data 
colnames(xData)<-features[,2]

xmean<-grep("mean\\(\\)",features[,2])
xstd<-grep("std\\(\\)",features[,2])
xData<-xData[,c(xmean,xstd)]

## Assigning descriptive activity names 

yData[, 1] <- activityLabels[yData[, 1], 2]
names(yData) <- "activity"
names(subject) <- "subject"

## Merging all the data

data<-cbind(yData,subject,xData)

## Average values for activity and subject with plyr Package

meanData <- ddply(data, .(subject, activity), function(x) colMeans(x[, 2:68]))
head(meanData, 13)

## Average values for activity and subject with reshape2 Package
## better method no need to specify variable columns

dataMelted <- melt(data, id = c("activity", "subject"))
head(dataMelted)
meanDataMelted <- dcast(dataMelted, activity + subject ~ variable, mean)
head(meanDataMelted,13)
write.table(meanDataMelted, "average.txt", row.names = FALSE, quote = FALSE)


