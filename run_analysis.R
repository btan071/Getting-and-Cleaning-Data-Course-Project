library(data.table)
library(dplyr)

# read names of features and activities data
activity_col <- read.table("UCI HAR Dataset/activity_labels.txt")
feature_col <- read.table("UCI HAR Dataset/features.txt")

# read train data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
feature_train <- read.table("UCI HAR Dataset/train/X_train.txt")

# read test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt")
feature_test <- read.table("UCI HAR Dataset/test/X_test.txt")

# merge the training and the test data (step 1)
subject <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
feature <- rbind(feature_train, feature_test)

colnames(feature) <- t(feature_col[2]) # transpose rows from 2nd column into columns
colnames(subject) <- "Subject"
colnames(activity) <- "Activity"
dataset <- cbind(subject, activity, feature)

# extract only the measurements on the mean and standard deviation for each measurement (step 2)
mean_std <- grep(".*Mean.*|.*Std.*|Subject|Activity", names(dataset), ignore.case=TRUE)
dataset_extract <- dataset[, mean_std]
head(dataset_extract)

# name the activities in the data set (step 3)
dataset_extract$Activity <- as.character(dataset_extract$Activity)
for (i in 1:6) {
  dataset_extract$Activity[dataset_extract$Activity == i] <- as.character(activity_col[i,2])
  } 
dataset_extract$Activity <- as.factor(dataset_extract$Activity) # replace activity number with its description

# re-label the data set appropriately (step 4)
names(dataset_extract)
names(dataset_extract) <- gsub("^t", "time", names(dataset_extract))
names(dataset_extract) <- gsub("^f", "freq", names(dataset_extract))
names(dataset_extract) <- gsub("tBody", "timeBody", names(dataset_extract))
head(dataset_extract)

# create a second, independent tidy data set with the average of each variable (step 5)
dataset_extract$Subject <- as.factor(dataset_extract$Subject)
dataset_extract <- data.table(dataset_extract)

dataset_tidy <- aggregate(. ~Subject + Activity, dataset_extract, mean)
dataset_tidy <- dataset_tidy[order(dataset_tidy$Subject,dataset_tidy$Activity),]
write.table(dataset_tidy, file = "tidy_dataset.txt", row.names = FALSE)

