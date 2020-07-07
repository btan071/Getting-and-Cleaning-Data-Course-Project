# Getting-and-Cleaning-Data-Course-Project
## Introduction 
One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data used in this project represents data collected from the accelerometers from the Samsung Galaxy S smartphone.Data used for this project can be found here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

An R script called run_analysis.R is created to address the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Extracting data 
### Libraries used 
The two libraries that we will be using are `data.table` and `dplyr`.
```
library(data.table)
library(dplyr)
```
### Supporting data used 
The supporting data includes the names of the activities and features, which are loaded into variables `activity_col` and `feature_col` respectively. 
```
activity_col <- read.table("UCI HAR Dataset/activity_labels.txt")
feature_col <- read.table("UCI HAR Dataset/features.txt")
```
### Train and test data
First, we read the train data and load them into variables `subject_train`, `activity_train` and `feature_train`.
```
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
feature_train <- read.table("UCI HAR Dataset/train/X_train.txt")
```

Next, we read the test data and load them into variables `subject_test`, `activity_test` and `feature_test`.
```
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt")
feature_test <- read.table("UCI HAR Dataset/test/X_test.txt")
```

## Step 1: Merging training and test data
Moving on, we combine both train and test data into each variable `subject`, `activity` and `feature` respectively. 
```
subject <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
feature <- rbind(feature_train, feature_test)
```
Next, we name the columns of each variable. The column names for `feature` can be found from the supporting data which we have previously stored in `feature_col`.
```
colnames(feature) <- t(feature_col[2])
colnames(subject) <- "Subject"
colnames(activity) <- "Activity"
```
Lastly, we combine the three variables into one dataset.
```
dataset <- cbind(subject, activity, feature)
```

## Step 2: Extracting only the measurements on the mean and standard deviation for each measurement
For this step, we extract columns that include either mean or std, as well as subject and activity, and load them into `mean_std`.
```
mean_std <- grep(".*Mean.*|.*Std.*|Subject|Activity", names(dataset), ignore.case=TRUE)
```
We then create another dataset called `dataset_extract` which contains the columns selected in `mean_std`.
```
dataset_extract <- dataset[, mean_std]
```
Take a look at how the extracted dataset looks like. 
```
head(dataset_extract)
```

## Step 3: Naming the activities in the dataset
Here, we will first convert the data under the `Activity` column from numeric to character type in order to label each data with a descriptive name.
```
dataset_extract$Activity <- as.character(dataset_extract$Activity)
```
The descriptive names for each activity can be retrieved from the supporting data which we have stored under `activity_col` previously. Now, each activity will appear as a descriptive name instead of a number.
```
for (i in 1:6) {
  dataset_extract$Activity[dataset_extract$Activity == i] <- as.character(activity_col[i,2])
  } 
```
Next, we factor the `Activity` variable. 
```
dataset_extract$Activity <- as.factor(dataset_extract$Activity) 
```

## Step 4: Re-labelling the dataset appropriately
We look at the column names of `dataset_extract` and identify those that require more meaningful names.
```
names(dataset_extract)
```
Rename those selected columns. 
```
names(dataset_extract) <- gsub("^t", "time", names(dataset_extract))
names(dataset_extract) <- gsub("^f", "freq", names(dataset_extract))
names(dataset_extract) <- gsub("tBody", "timeBody", names(dataset_extract))
```
Take a look at the renamed columns.
```
head(dataset_extract)
```

## Step 5: Creating a second, independent tidy data set with the average of each variable
Firstly, set `Subject` as a factor variable.
```
dataset_extract$Subject <- as.factor(dataset_extract$Subject)
dataset_extract <- data.table(dataset_extract)
```
Next, create variable `dataset_tidy` which collates the average of each variable for each activity and each subject.
```
dataset_tidy <- aggregate(. ~Subject + Activity, dataset_extract, mean)
```
Order by `Subject`, then by `Activity`.
```
dataset_tidy <- dataset_tidy[order(dataset_tidy$Subject, dataset_tidy$Activity),]
```
Lastly, write the processed data into a new file `tidy_dataset.txt`.
```
write.table(dataset_tidy, file = "tidy_dataset.txt", row.names = FALSE)
```
