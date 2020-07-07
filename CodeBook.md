# CodeBook
## Dataset used 
The data used for this project can be retrieved from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Input data
The input data consists of the following files:

- `features.txt`: List of all features.
- `activity_labels.txt`: Links the class labels with their activity name.
- `X_train.txt`: Training set.
- `y_train.txt`: Training labels.
- `X_test.txt`: Test set.
- `y_test.txt`: Test labels.
- `subject_train.txt`: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- `subject_test.txt`: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

## Transformations

- `activity_col`: Variable containing `activity_labels.txt`
- `feature_col`: Variable containing `features.txt`
- `subject_train`: Variable containing `subject_train.txt`
- `activity_train`: Variable containing `y_train.txt`
- `feature_train`: Variable containing `X_train.txt`
- `subject_test`: Variable containing `subject_test.txt`
- `activity_test`: Variable containing `y_test.txt`
- `feature_test`: Variable containing `X_test.txt`
- `subject`, `activity` and `feature`: Variables containing merged train and test data of `subject`, `activity` and `feature`
- `dataset`: Variable containing full dataset 
- `dataset_extract`: Variable containing only specific columns that include mean, std, subject and activity
- `dataset_tidy`: Variable containing data with average of each variable for each activity and subject of `dataset_extract`

## Output data
Processed data from `dataset_tidy` is written into `tidy_dataset.txt`
