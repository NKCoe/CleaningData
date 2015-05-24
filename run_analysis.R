setwd("/Users/nat/Desktop/Coursera-Data Science/3_Getting and cleaning data/Assignment/")

#1 Merges the training and the test sets to create one data set.
#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names. 
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Download the data
testing<- read.table("Data/test/X_test.txt",sep="",header=FALSE)
training<- read.table("Data/train/X_train.txt",sep="",header=FALSE)

#Add column for activity code 
testing[,562]<- read.table("Data/test/y_test.txt",sep="",header=FALSE)
training[,562] <- read.table("Data/train/y_train.txt",sep="",header=FALSE)

#Adding column for participant IDs
testing[,563]<- read.table("Data/test/subject_test.txt",sep="",header=FALSE)
training[,563]<-read.table("Data/train/subject_train.txt",sep="",header=FALSE)

#Download features and improve heading names
features <- read.table("Data/features.txt",sep="",header=FALSE)
features$V1 <-NULL
features[,1]<- gsub("-"," ",features[,1])
features[,1]<- gsub("mean","Mean",features[,1])
features[,1]<-gsub("std","Std",features[,1])

#Merge training and test data
Data<- rbind(testing,training)

#Get only Mean and Std
#select row numbers corresponding to Mean and Std
MyCol<- grep(".*Mean.*|.*Std.*",features[,1])
#reduce features to the numbers relating to columns we want
features<-features[MyCol,]
#add last two column numbers(activity and subject)
MyCol <- c(MyCol,562,563)
#remove unwanted columns from data by selecting right column numbers
Data<- Data[,MyCol]
#add column names to data
colnames(Data)<-c(features,"activity","participant_ID")

#Download activity labels
activityNames <- read.table("Data/activity_labels.txt",sep="",header=FALSE)
#Convert activity code to activity name
CurrentActivity =1
for(CurrentActivityLabel in activityNames$V2)
{
        Data$activity <- gsub(CurrentActivity,CurrentActivityLabel, Data$activity)
        CurrentActivity <-CurrentActivity+1
}

Data$activity <- as.factor(Data$activity)
Data$participant_ID <- as.factor(Data$participant_ID)

#tidy data
tidy= aggregate(Data,by=list(activity=Data$activity,participant=Data$participant_ID),mean)
#remove average of activity and participant column as no meaning
tidy[,90]<-NULL
tidy[,89]<-NULL
#create tidy file in working directory
write.table(tidy,"tidy.txt",sep=",",row.names=FALSE)



