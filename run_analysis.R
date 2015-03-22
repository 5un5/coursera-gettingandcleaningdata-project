########################################################
# run.analysis.R created for Coursera class, by Sunshine
# based on data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#  Merges training and test sets into one data set, called "merged_data"
#  Extracts mean and standard deviation for each measurement
#  Creates another data set, "tidy_data" with the average of each variable for each activity and subject
########################################################

# Load and Merge data sets
testing_data  <- read.table(file="~/UCI HAR Dataset/test/X_test.txt")
training_data <- read.table(file="~/UCI HAR Dataset/train/X_train.txt")
merged_data   <- rbind(training_data,testing_data)

# Add column names
names<-read.csv("~UCI HAR Dataset/features.txt",sep=" ",header = F)
colnames(merged_data) <- names$V2

# Extract means and standard deviations
means <- merged_data[,grep("mean\\(", names(merged_data))]
standard_deviations <- merged_data[,grep("std\\(", names(merged_data))]

# Create column of activities
activity_testing_data  <- read.table(file="Desktop/working/UCI HAR Dataset/test/y_test.txt")
activity_training_data <- read.table(file="Desktop/working/UCI HAR Dataset/train/y_train.txt")
merged_activities      <- rbind(activity_training_data,activity_testing_data)
activity_labels <- read.table(file="Desktop/working/UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels)<-c("activity_number","activity_name")
activities <- (activity_labels$activity_name)[ match(merged_activities$V1,activity_labels$activity_number ) ]
# Add activities to means and standard deviations
means<-cbind(activities,means)
standard_deviations<-cbind(activities,standard_deviations)

### Create "tidy_data" data set 
# create a matrix for means and another for standard deviations

AverageMeans<-matrix(, nrow = 6, ncol = 33)
rownames(AverageMeans) <- activity_labels$activity_name
colnames(AverageMeans) <- as.vector(colnames(means))[2:ncol(means)]

AverageStandardDeviations<-matrix(, nrow = 6, ncol = 33)
rownames(AverageStandardDeviations) <- activity_labels$activity_name
colnames(AverageStandardDeviations) <- as.vector(colnames(standard_deviations))[2:ncol(standard_deviations)]

# Fill each matrix with the metrics (means and standard deviations), subsetted for each activity
for(a in activity_labels$activity_number){
  activity <- activity_labels$activity_name[a]

  means_activity_subset               <- subset(means,activities==activity)
  means_activity_subset               <- means_activity_subset[,2:ncol(means_activity_subset)]
  standard_deviations_activity_subset <- subset(standard_deviations,activities==activity)
  standard_deviations_activity_subset <- standard_deviations_activity_subset[,2:ncol(standard_deviations_activity_subset)]

  AverageMeans[a,]              <- apply(X=means_activity_subset,              MARGIN = 2,FUN = "mean")
  AverageStandardDeviations[a,] <- apply(X=standard_deviations_activity_subset,MARGIN = 2,FUN = "sd")
}

# Put the averages together into one table
tidy_data<-cbind(AverageMeans,AverageStandardDeviations)
# Output
tidy_data
