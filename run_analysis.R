# change working directory
setwd("~/Desktop/coursera /getting and cleaning data/final project/UCI HAR Dataset")
library(plyr)

#step 1

#read both test files and training files into R
x_test<-read.table("test/X_test.txt")
y_test<-read.table("test/y_test.txt")
subject_test<-read.table("test/subject_test.txt")

x_train<-read.table("train/X_train.txt")
y_train<-read.table("train/y_train.txt")
subject_train<-read.table("train/subject_train.txt")

## combine data by x,y and subject
x_all<-rbind(x_train,x_test)
y_all<-rbind(y_train,y_test)
subject_all<-rbind(subject_train,subject_test)

#step 2

## read features.txt into R
features<-read.table("features.txt")

##subset dataset by mean and std
features_mean_std<-grep(pattern = "-(mean|std)\\(\\)",features[,2])
x_mean_std<-x_all[,features_mean_std]

#give column names for each variables in x_mean_std
colnames(x_mean_std)<-features[features_mean_std,2]

#step 3

#read activity_labels into R
activities<-read.table("activity_labels.txt")

#substitute activity label in y_all with activity names
y_all[,1]<-activities[y_all[,1],2]
names(y_all)<-c("activities")

#step 4
#combine x_mean_std,y_all and subject_all
names(subject_all)<-c("subject")
alldata<-cbind(subject_all,y_all,x_mean_std)

#step 5
#Create a second,independent tidy data set with the average of each variable for each 
#activity and subject
average_alldata<-ddply(alldata,.(activities,subject),function(x) colMeans(x[,3:68]))

write.table(average_alldata,"average_alldata.txt",row.names = FALSE)