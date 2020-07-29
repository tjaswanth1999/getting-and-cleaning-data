file.url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#downloading the file
download.file(file.url, destfile = "./datacleaning/projectdataset.zip")
#downloaded file must be unzipped for the further use
unzip(zipfile = "./datacleaning/projectdataset.zip", exdir = "./datacleaning")

#objective 1

#for merging the tables initially we will read all the test, train datasets along with features, activity data sets

#reading train data
x_train=read.table("./datacleaning/UCI HAR Dataset/train/X_train.txt")
y_train=read.table("./datacleaning/UCI HAR Dataset/train/y_train.txt")
subject_train=read.table("./datacleaning/UCI HAR Dataset/train/subject_train.txt")

#reading testdata
x_test=read.table("./datacleaning/UCI HAR Dataset/test/X_test.txt")
y_test=read.table("./datacleaning/UCI HAR Dataset/test/y_test.txt")
subject_test=read.table("./datacleaning/UCI HAR Dataset/test/subject_test.txt")

#reading featured data
features=read.table("./datacleaning/UCI HAR Dataset/features.txt")

#reading activity labels
activity_labels=read.table("./datacleaning/UCI HAR Dataset/activity_labels.txt")

#assigning variable names for train data
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"


#assigning variable names for test data
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

#assigning variable names for activity labels
colnames(activity_labels) <- c("activityID", "activityType")

#merging all the datasets into a single dataset
alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
finaldataset <- rbind(alltrain, alltest)


#objective 2

# reading all the column names that are in the final dataset
colNames = colnames(finaldataset)

#we will draw a subset of all the mean and standard deviation and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityID" , colNames) | grepl("subjectID" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

#A subtset has to be created to get the required dataset
setForMeanAndStd <-finaldataset[ , mean_and_std == TRUE]


#objective 3

#naming the activities in the data
setWithActivityNames = merge(setForMeanAndStd, activity_labels, by="activityID", all.x=TRUE)
setWithActivityNames<-setWithActivityNames[,-82]
#objective 4

# New tidy set has to be created 
secTidySet <- aggregate(.~subjectID+activityID,setWithActivityNames,mean,na.action = na.omit)
secTidySet <- secTidySet[order(secTidySet$subjectID, secTidySet$activityID),]
secTidySet
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
