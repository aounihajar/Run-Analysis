
#https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/

#Getting and Cleaning Data Course Project

#This file be loaded using command 'source("../Project/run_analysis.r")'

#Settings the environment
timeStart <- Sys.time()
library(dplyr)

top <- -1  # reading number of lines. It should be -1 to read the whole file
dir <- "/Users/aouni/Documents/R/03-Getting and Cleaning Data/UCI HAR Dataset/"
setwd(dir)
save_output <- function (frame, file = "output.csv") {
        write.table(frame, 
                    file = file,
                    sep = ",",
                    col.names = TRUE,
                    row.names = FALSE
        )
}


##### Question 1: Merges the training and the test sets to create one data set
##### + Question 2: Extracts only the measurements on the mean and standard deviation for each measurement.
##### + Question 3: Uses descriptive activity names to name the activities in the data set
##### + Question 4: Appropriately labels the data set with descriptive variable names.

#Loading variable names for X_train.txt file
file <- "./features.txt"
var_names <- read.csv(
        sep = " ",
        colClasses = c("character"),
        file = file,
        header = FALSE,
        col.names = c("id", "var_name"))

#Cleaning variable names
var_names$var_name <- gsub("(\\.|\\(|\\)|-|,)+", "", var_names$var_name)
var_names$var_name <- tolower(var_names$var_name)

#Loading Activity Labels
file <- "./activity_labels.txt"
activity_labels <- read.csv(
        sep = " ",
        colClasses = c("character"),
        file = file,
        header = FALSE,
        col.names = c("id", "activity_labels"))

#Loading subject_train.txt file
file <- "./train/subject_train.txt"
subject_train <- read.fwf(
        file = file,
        header = FALSE,
        col.names = c("subject_id"),
        skip=0,
        n = top,
        widths=2)

#Loading Y_train.txt file
file <- "./train/y_train.txt"
y_train <- read.fwf(
        file = file,
        header = FALSE,
        col.names = c("activity_code"),
        skip=0,
        n = top,
        widths=2)

#Loading X_train.txt file
file <- "./train/X_train.txt"
x_train <- read.fwf(
        file = file,
        skip=0,
        n = top,
        col.names = var_names$var_name,
        widths=rep(16, 561))

#####Extracts only the measurements on the mean and standard deviation for each measurement.
meansurement_variables <- grep ("mean|std", names(x_train), value=TRUE) 
x_train_mean_std <- select (x_train, meansurement_variables)

#Merging the variables for x_train, y_train, and subject_train data frames into one unified data frame
tidy_train <- cbind(subject_train, y_train, x_train_mean_std)
#save_output(tidy_train)

#########################

#Loading subject_test.txt file
file <- "./test/subject_test.txt"
subject_test <- read.fwf(
        file = file,
        header = FALSE,
        col.names = c("subject_id"),
        skip=0,
        n = top,
        widths=2)

#Loading y_test.txt file
file <- "./test/y_test.txt"
y_test <- read.fwf(
        file = file,
        header = FALSE,
        col.names = c("activity_code"),
        skip=0,
        n = top,
        widths=2)

#Cleaning y_test
#y_test <- merge (y_test_temp, 
#                  activity_labels, 
#                  by.x = "activity_code",
#                  by.y = "id",
#                  all.x = TRUE)

#Loading X_test.txt file
file <- "./test/X_test.txt"
x_test <- read.fwf(
        file = file,
        skip=0,
        n = top,
        col.names = var_names$var_name,
        widths=rep(16, 561))

#####Extracts only the measurements on the mean and standard deviation for each measurement.
meansurement_variables <- grep ("mean|std", names(x_test), value=TRUE) 
x_test_mean_std <- select (x_test, meansurement_variables)

#Merging the variables for x_train, y_train, and subject_train data frames into one unified data frame
tidy_test <- cbind(subject_test, y_test, x_test_mean_std)

#save_output(tidy_test)

#Combining tidy_train and tidy_test
tidy_temp <- rbind(tidy_train, tidy_test)

#Cleaning y_train
tidy <- merge (tidy_temp, 
                  activity_labels, 
                  by.x = "activity_code",
                  by.y = "id",
                  all.x = TRUE)
tidy$activity_code <- NULL
tidy <- dplyr::arrange (tidy, subject_id, activity_labels)
tidy_temp <- dplyr::rename(tidy, subjectid = subject_id, activitylabels = activity_labels)
save_output(tidy_temp)


##### Question 5: From the data set in step 4 (i.e. tidy), creates a second, 
##                independent tidy data set with the average of each variable 
##                for each activity and each subject.
tidy_group <- group_by (tidy, subject_id, activity_labels)
tidy_group %>% group_by (subject_id, activity_labels) %>% summarise_each(funs(mean)) -> tidy_aggregate
tidy_aggregate <- arrange (tidy_aggregate, subject_id, activity_labels)
tidy_aggregate <- dplyr::rename(tidy_aggregate, subjectid = subject_id, activitylabels = activity_labels)
save_output(tidy_aggregate, "tidy_aggregate.csv")

timeEnd <- Sys.time()
timeTask <- round (as.numeric(timeEnd - timeStart), 2)
print (paste0("Execution time for processing ", nrow(tidy), " rows is ", timeTask, " seconds"))

