## 
## run_analysis.R
##
## 1. merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement
## 3. Uses descriptive activity names to name the activities in the data set.
## 4. Appropriately labels the data set with descriptive variable names.  
## 5. From the data set in step 4, cretes a second, independent tidy data set with the average of 
##    each variable for each activity and each subject.
##
##
library (dplyr)
library (tidyr)
##
## read in test data
##
test_file_loc <- "./data/test/X_test.txt"
test_df <- read.table(test_file_loc)
##
## convert dataframe to datatable
##
test_dt <- tbl_df(test_df)
rm("test_df")
##
## read in test subject list
##
test_subject_file_loc <- "./data/test/subject_test.txt"
test_subject_df <- read.table(test_subject_file_loc)
##
## convert dataframe to datatable
##
test_subject_dt <- tbl_df(test_subject_df)
rm("test_subject_df")
##
## read in training file
##
train_file_loc <- "./data/train/X_train.txt"
train_df <- read.table(train_file_loc)
## 
## convert dataframe to datatable
##
train_dt <- tbl_df(train_df)
rm("train_df")
#
test_variable_list_loc <- "./data/features.txt"
test_variable_list <- read.table(test_variable_list_loc)
##
## replace column generic vector names with test_variable_list
## on both the test and training data sets
##
colnames(test_dt) <- test_variable_list[ ,2]
colnames(train_dt) <- test_variable_list[ ,2]
##
## select the mean and standard deviation for each measurement
##
# subset the data sets based on 'mean' or 'std' contained in the variable name
##
test_dt_mean_std <- test_dt[,(grepl('mean',test_variable_list[,2]) | 
                              grepl('std', test_variable_list[,2]))]
train_dt_mean_std <- train_dt[,(grepl('mean',test_variable_list[,2]) |
                                       grepl('std',test_variable_list[,2]))]
rm(test_dt)  ## cleaning up files no longer needed
rm(train_dt)
##
## add on the activity column
## read test-data activity col data:
test_activity_loc <- "./data/test/y_test.txt"
y_test_df <- read.table(test_activity_loc)
y_test_dt <- tbl_df(y_test_df)
rm(y_test_df)
##
## train-data activity column read:
train_activity_loc <- "./data/train/y_train.txt"
y_train_df <- read.table(train_activity_loc)
y_train_dt <- tbl_df(y_train_df)
rm(y_train_df)
##
## insert the test activity column
xy_test_dt <- cbind(y_test_dt,test_dt_mean_std)
rm(y_test_dt)
rm(test_dt_mean_std)
## insert the train activity column
xy_train_dt <- cbind(y_train_dt,train_dt_mean_std)
rm(y_train_dt)
rm(train_dt_mean_std)

## rename the activity column for test and train datatables
xyact_dt <- rename(xy_test_dt,activity=V1)
rm(xy_test_dt)
xyact_train_dt <- rename(xy_train_dt,activity=V1)
rm(xy_train_dt)
##
## swap out the activity number for a descriptive activity name
##
activity_list = c("walking", "walking_upstairs", "walking_downstairs",
                  "sitting", "standing", "laying")
tidy_test_dt <- mutate(xyact_dt,activity=activity_list[activity])
rm(xyact_dt)
tidy_train_dt <- mutate(xyact_train_dt,activity=activity_list[activity])
rm(xyact_train_dt)
##
## add in the subject column
##
## subject col test-data read in:
test_subject_loc <- "./data/test/subject_test.txt"
subject_test_df <- read.table(test_subject_loc)
subject_test_dt <- tbl_df(subject_test_df)
rm(subject_test_df)
##
## subject col train-data read in:
train_subject_loc <- "./data/train/subject_train.txt"
subject_train_df <- read.table(train_subject_loc)
subject_train_dt <- tbl_df(subject_train_df)
rm(subject_train_df)
##
## attach subject column to test datatable:
xsub_test_dt <- cbind(subject_test_dt,tidy_test_dt)
rm(tidy_test_dt)
rm(subject_test_dt)
## attache subject column to train datatable:
xsub_train_dt <- cbind(subject_train_dt,tidy_train_dt)
rm(tidy_train_dt)
rm(subject_train_dt)
##
## rename the subject column for test and train datatable
xysub_dt <- rename(xsub_test_dt,subject=V1)
rm(xsub_test_dt)
xysub_train_dt <- rename(xsub_train_dt,subject=V1)
rm(xsub_train_dt)
##
## merge the training and test data sets
##
tidy.dt <- rbind(xysub_dt,xysub_train_dt)
rm(xysub_dt)
rm(xysub_train_dt)
##
## calculate mean on all data variables grouped by subject and activity
## use aggregate function.  Subject is in col#1, activity is in col#2
## the data to be averaged is in columns 3 to 81
##
answer.dt <- aggregate(tidy.dt[,3:81], list(tidy.dt$subject, tidy.dt$activity),mean)
## 
## rename Group.1 to subject, Group.2 to activity
##
answer.dt <- rename(answer.dt, subject = Group.1, activity = Group.2)
##
## Write out the file.
## 
write_file_name = "./average.txt"
write.table(answer.dt,write_file_name,row.name=FALSE)
##
## done

