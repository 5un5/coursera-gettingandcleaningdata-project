# coursera-gettingandcleaningdata-project
Describes course project

OVERVIEW

In addition to this file, this repository contains an R script run_analysis.R, a codebook describing variables, and a license.

Description of run_analysis.R

run.analysis.R was created for the Coursera class, Getting and Cleaning Data. Created by Sunshine.
It uses data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

This README file contains a description of an R file that:
1.  Loads and merges data from a training set and test set, into a single data set, called "merged_data"
2.  Extracts mean and standard deviation (SD) for each measurement
3.  Outputs a new data set, called "tidy_data" with the average of each variable for each activity and subject
########################################################

1. Loading and Merging data
testing_data and training_data are read in as tables from the UCI HAR Dataset in the home directory.
Their rows are combined into merged_data using rbind.
This merged data set is given column names from features.txt

2. Extracting meand and SD
Columns containing means or standard deviations are selected out using grep. At this point I decided to keep the 2 kinds of metrics (means and SDs) separate, because it makes more sense to think of them independently.

3. Create and output "tidy_data" a table that holds the  average means and SDs for each activity.
Next the data was correlated with the 6 activities, stored in activity_labels.txt.
We create a new column holding the activity that goes with each row's observations.
These activities come from reading in and merging the y_test and y_train files.
As above, we use rbind.
We also create a table for the 6 activity_labels.
Using merge to make the activities from the merged activity vector more readable, we replace all the numbers, 1-6 representing activities, with the character terms to label the activities.
Then, using cbind, we add this vector of activity terms to the tables of means and standard deviations we created in step 2 above.

Now we are ready to create the new matrix. 
It starts as 2 matrices, AverageMeans and AverageStandardDeviations; each is 6 x 33 because there are 6 kinds of activities and 33 means and 33 standard deviations.

We fill in these matrices by looping throught the 6 activities.
For each activity, we subsetting the means and SD by activity.
Then, we trim off the first column containing the activity, before calculating the means and SDs of each metric, using the "apply" function with "mean" and "sd".

Finally we combine the AverageMeans and the AverageStandardDeviations using cbind, and output the final table,
"tidy_data".
