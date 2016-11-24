install.packages("reshape2")
library("reshape2")
#download and unzip the data set

if(!file.exists("data.zip")){

  url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url,"data.zip")
  unzip("data.zip")
  
}

# Extracts only the measurements on the mean and standard deviation for each measurement

features<-read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
featuresMS<-grep(".*mean.*|.*set.*",features[,2])
featuresMS.name<-features[featuresMS,2]

#read test data set

test<-read.table("UCI HAR Dataset/test/X_test.txt")
test<-test[featuresMS]
ytest<- read.table("UCI HAR Dataset/test/Y_test.txt")
subjectstest <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subjectstest, ytest, test)


#read train data set

train<-read.table("UCI HAR Dataset/train/X_train.txt")
train<-train[featuresMS]
ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjectstrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subjectstrain, ytrain, train)


#merge data set and labels the data set with descriptive variable names.

dataset<-rbind(test,train)
colnames(dataset)<-c("subjects","Activity",featuresMS.name)


#descriptive activity names to name the activities in the data set

activityLabels<-read.table("UCI HAR Dataset/activity_labels.txt")
dataset$Activity<-factor(dataset$Activity,levels=activityLabels[,1],labels=activityLabels[,2])

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

dataset.melted <- melt(dataset, id = c("subjects", "Activity"))
dataset.mean <- dcast(dataset.melted, subjects + Activity ~ variable, mean)

write.table(dataset.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
