# getDataCourseProject
## 
## 
## Getting and Cleaning Data Course Project Directions: 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, cretes a second, independent tidy data set with the average of each variable for each activity and each subject.
###
### run_analysis.R description:
#### Notes:
*  Library (dplyr) is used
*  All data files are read in from the "./data" sub-directory
*  Dataframes are converted to datatables since the dplyr package is being used in this project,
*  Dataframes are removed after conversion to datatables.
*  Results file can be found at "./average.txt" 
*  Use read.table("./average.txt) to read in the file into a R dataframe
###  
### Sequence of operations:
1. read in test data and train data into dataframes, convert dataframes to datatable format since we are usind dplyr
2. attach variable names to columns using the test_subject.txt file 
  1. subset the test and train datatables to only include variables which have 'mean' or 'std' in their name
3. read in the test and train activity files and add as columns to the test and training data sets
  1. replace the numeric activity code observations with descriptive observation text such as walking, standing, etc.
4. read in the test and train subject files and add as columns to the test and training data sets
5. rename the subject and activity column names to "subject" and "activity" in both the test and train datatables
6. merge the test and training datatables using the rbind() function.
7. use the aggregate() function to take the mean of all of the measurements, grouping over the subject and activity variables
8. write the resulting datatable of means to "./average.txt"
9. Done!
##
## 
