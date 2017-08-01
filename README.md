Objectives
----------

This course project for Cleaning and Getting Data course is written in R
Language. The main objective is to be able to collect, work, and clean
data from different sources and formats. This R program delivers the
following:

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation
    for each measurement.
3.  Uses descriptive activity names to name the activities in the data
    set
4.  Appropriately labels the data set with descriptive variable names.
5.  From the data set in step 4, creates a second, independent tidy data
    set with the average of each variable for each activity and
    each subject.

#### Input Data

There are two main data sets used in the program; training and test
data. All datasets are provided from "UCI HAR Dataset"

The following is setting the global environment.

    top <- -1  # reading number of lines. It should be -1 to read the whole file

    library(dplyr)
    timeStart <- Sys.time()

Loading Activity Labels
-----------------------

This section demonstrates loading activity labels from
activity\_labels.txt.

    file <- "../UCI HAR Dataset/activity_labels.txt"
    activity_labels <- read.csv(
            sep = " ",
            colClasses = c("character"),
            file = file,
            header = FALSE,
            col.names = c("id", "activity_labels"))
    head(activity_labels)

    ##   id    activity_labels
    ## 1  1            WALKING
    ## 2  2   WALKING_UPSTAIRS
    ## 3  3 WALKING_DOWNSTAIRS
    ## 4  4            SITTING
    ## 5  5           STANDING
    ## 6  6             LAYING

Loading and Cleaning Variable Names
-----------------------------------

This section demonstrates loading and cleaning Variable names from
features.txt.

### Data Loading

    file <- "../UCI HAR Dataset/features.txt"
    var_names <- read.csv(
            sep = " ",
            colClasses = c("character"),
            file = file,
            header = FALSE,
            col.names = c("id", "var_name"))
    head(var_names)

    ##   id          var_name
    ## 1  1 tBodyAcc-mean()-X
    ## 2  2 tBodyAcc-mean()-Y
    ## 3  3 tBodyAcc-mean()-Z
    ## 4  4  tBodyAcc-std()-X
    ## 5  5  tBodyAcc-std()-Y
    ## 6  6  tBodyAcc-std()-Z

### Data Cleaning

    var_names$var_name <- gsub("(\\.|\\(|\\)|-|,)+", "", var_names$var_name)
    var_names$var_name <- tolower(var_names$var_name)
    head(var_names)

    ##   id      var_name
    ## 1  1 tbodyaccmeanx
    ## 2  2 tbodyaccmeany
    ## 3  3 tbodyaccmeanz
    ## 4  4  tbodyaccstdx
    ## 5  5  tbodyaccstdy
    ## 6  6  tbodyaccstdz

Loading Subject Training
------------------------

This section demonstrates loading subject training from
subject\_train.txt.

    #Loading subject_train.txt file
    file <- "../UCI HAR Dataset/train/subject_train.txt"
    subject_train <- read.fwf(
            file = file,
            header = FALSE,
            col.names = c("subject_id"),
            skip=0,
            n = top,
            widths=2)
    head(subject_train)

    ##   subject_id
    ## 1          1
    ## 2          1
    ## 3          1
    ## 4          1
    ## 5          1
    ## 6          1

Loading Y Training
------------------

This section demonstrates loading y training from subject\_train.txt.

    file <- "../UCI HAR Dataset/train/y_train.txt"
    y_train <- read.fwf(
            file = file,
            header = FALSE,
            col.names = c("activity_code"),
            skip=0,
            n = top,
            widths=2)
    head(y_train)

    ##   activity_code
    ## 1             5
    ## 2             5
    ## 3             5
    ## 4             5
    ## 5             5
    ## 6             5

Loading X Training with Variable Names
--------------------------------------

This section demonstrates loading y training from subject\_train.txt.

    file <- "../UCI HAR Dataset/train/X_train.txt"
    x_train <- read.fwf(
            file = file,
            skip=0,
            n = top,
            col.names = var_names$var_name,
            widths=rep(16, 561))
    x_train[1,1:20]

    ##   tbodyaccmeanx tbodyaccmeany tbodyaccmeanz tbodyaccstdx tbodyaccstdy
    ## 1     0.2885845   -0.02029417    -0.1329051   -0.9952786   -0.9831106
    ##   tbodyaccstdz tbodyaccmadx tbodyaccmady tbodyaccmadz tbodyaccmaxx
    ## 1   -0.9135264   -0.9951121   -0.9831846    -0.923527   -0.9347238
    ##   tbodyaccmaxy tbodyaccmaxz tbodyaccminx tbodyaccminy tbodyaccminz
    ## 1   -0.5673781   -0.7444125    0.8529474    0.6858446    0.8142628
    ##   tbodyaccsma tbodyaccenergyx tbodyaccenergyy tbodyaccenergyz tbodyacciqrx
    ## 1  -0.9655228      -0.9999446       -0.999863      -0.9946122   -0.9942308

### Milestone 1: Tidy Data for Training

This section demonstrates 1. Selecting only variables which measure
means and standard deviations 2. cleaning x\_train by from the selected
variable names 3. Combine subject\_train, y\_train and the cleaned
x\_train

### Step 1

    meansurement_variables <- grep ("mean|std", names(x_train), value=TRUE)
    head(meansurement_variables)

    ## [1] "tbodyaccmeanx" "tbodyaccmeany" "tbodyaccmeanz" "tbodyaccstdx" 
    ## [5] "tbodyaccstdy"  "tbodyaccstdz"

### Step 2

    x_train_mean_std <- select (x_train, meansurement_variables)
    x_train_mean_std[1, 1:20]

    ##   tbodyaccmeanx tbodyaccmeany tbodyaccmeanz tbodyaccstdx tbodyaccstdy
    ## 1     0.2885845   -0.02029417    -0.1329051   -0.9952786   -0.9831106
    ##   tbodyaccstdz tgravityaccmeanx tgravityaccmeany tgravityaccmeanz
    ## 1   -0.9135264        0.9633961       -0.1408397        0.1153749
    ##   tgravityaccstdx tgravityaccstdy tgravityaccstdz tbodyaccjerkmeanx
    ## 1      -0.9852497      -0.9817084       -0.877625        0.07799634
    ##   tbodyaccjerkmeany tbodyaccjerkmeanz tbodyaccjerkstdx tbodyaccjerkstdy
    ## 1       0.005000803       -0.06783081       -0.9935191         -0.98836
    ##   tbodyaccjerkstdz tbodygyromeanx tbodygyromeany
    ## 1        -0.993575   -0.006100849    -0.03136479

### Step 3

    tidy_train <- cbind(subject_train, y_train, x_train_mean_std)
    tidy_train[1, 1:20]

    ##   subject_id activity_code tbodyaccmeanx tbodyaccmeany tbodyaccmeanz
    ## 1          1             5     0.2885845   -0.02029417    -0.1329051
    ##   tbodyaccstdx tbodyaccstdy tbodyaccstdz tgravityaccmeanx tgravityaccmeany
    ## 1   -0.9952786   -0.9831106   -0.9135264        0.9633961       -0.1408397
    ##   tgravityaccmeanz tgravityaccstdx tgravityaccstdy tgravityaccstdz
    ## 1        0.1153749      -0.9852497      -0.9817084       -0.877625
    ##   tbodyaccjerkmeanx tbodyaccjerkmeany tbodyaccjerkmeanz tbodyaccjerkstdx
    ## 1        0.07799634       0.005000803       -0.06783081       -0.9935191
    ##   tbodyaccjerkstdy tbodyaccjerkstdz
    ## 1         -0.98836        -0.993575

    nrow(tidy_train)

    ## [1] 7352

Loading Subject Testing
-----------------------

This section demonstrates loading subject testing from
subject\_test.txt.

    #Loading subject_test.txt file
    file <- "../UCI HAR Dataset/test/subject_test.txt"
    subject_test <- read.fwf(
            file = file,
            header = FALSE,
            col.names = c("subject_id"),
            skip=0,
            n = top,
            widths=2)
    head(subject_test)

    ##   subject_id
    ## 1          2
    ## 2          2
    ## 3          2
    ## 4          2
    ## 5          2
    ## 6          2

Loading Y Testing
-----------------

This section demonstrates loading y testing from subject\_test.txt.

    file <- "../UCI HAR Dataset/test/y_test.txt"
    y_test <- read.fwf(
            file = file,
            header = FALSE,
            col.names = c("activity_code"),
            skip=0,
            n = top,
            widths=2)
    head(y_test)

    ##   activity_code
    ## 1             5
    ## 2             5
    ## 3             5
    ## 4             5
    ## 5             5
    ## 6             5

Loading X Testing with Variable Names
-------------------------------------

This section demonstrates loading y testing from subject\_test.txt.

    file <- "../UCI HAR Dataset/test/X_test.txt"
    x_test <- read.fwf(
            file = file,
            skip=0,
            n = top,
            col.names = var_names$var_name,
            widths=rep(16, 561))
    x_test[1,1:20]

    ##   tbodyaccmeanx tbodyaccmeany tbodyaccmeanz tbodyaccstdx tbodyaccstdy
    ## 1     0.2571778   -0.02328523   -0.01465376    -0.938404   -0.9200908
    ##   tbodyaccstdz tbodyaccmadx tbodyaccmady tbodyaccmadz tbodyaccmaxx
    ## 1   -0.6676833   -0.9525011   -0.9252487   -0.6743022   -0.8940875
    ##   tbodyaccmaxy tbodyaccmaxz tbodyaccminx tbodyaccminy tbodyaccminz
    ## 1   -0.5545772    -0.466223    0.7172085    0.6355024    0.7894967
    ##   tbodyaccsma tbodyaccenergyx tbodyaccenergyy tbodyaccenergyz tbodyacciqrx
    ## 1  -0.8777642      -0.9977661      -0.9984138      -0.9343453    -0.975669

Milestone 2: Tidy Data for Testing
==================================

This section demonstrates 1. Selecting only variables which measure
means and standard deviations 2. cleaning x\_test by from the selected
variable names 3. Combine subject\_test, y\_test and the cleaned x\_test

### Step 1

    meansurement_variables <- grep ("mean|std", names(x_test), value=TRUE)
    head(meansurement_variables)

    ## [1] "tbodyaccmeanx" "tbodyaccmeany" "tbodyaccmeanz" "tbodyaccstdx" 
    ## [5] "tbodyaccstdy"  "tbodyaccstdz"

### Step 2

    x_test_mean_std <- select (x_test, meansurement_variables)
    x_test_mean_std[1, 1:20]

    ##   tbodyaccmeanx tbodyaccmeany tbodyaccmeanz tbodyaccstdx tbodyaccstdy
    ## 1     0.2571778   -0.02328523   -0.01465376    -0.938404   -0.9200908
    ##   tbodyaccstdz tgravityaccmeanx tgravityaccmeany tgravityaccmeanz
    ## 1   -0.6676833        0.9364893       -0.2827192        0.1152882
    ##   tgravityaccstdx tgravityaccstdy tgravityaccstdz tbodyaccjerkmeanx
    ## 1      -0.9254273      -0.9370141      -0.5642884        0.07204601
    ##   tbodyaccjerkmeany tbodyaccjerkmeanz tbodyaccjerkstdx tbodyaccjerkstdy
    ## 1         0.0457544        -0.1060427       -0.9066828       -0.9380164
    ##   tbodyaccjerkstdz tbodygyromeanx tbodygyromeany
    ## 1       -0.9359358      0.1199762    -0.09179234

### Step 3

    tidy_test <- cbind(subject_test, y_test, x_test_mean_std)
    tidy_test[1, 1:20]

    ##   subject_id activity_code tbodyaccmeanx tbodyaccmeany tbodyaccmeanz
    ## 1          2             5     0.2571778   -0.02328523   -0.01465376
    ##   tbodyaccstdx tbodyaccstdy tbodyaccstdz tgravityaccmeanx tgravityaccmeany
    ## 1    -0.938404   -0.9200908   -0.6676833        0.9364893       -0.2827192
    ##   tgravityaccmeanz tgravityaccstdx tgravityaccstdy tgravityaccstdz
    ## 1        0.1152882      -0.9254273      -0.9370141      -0.5642884
    ##   tbodyaccjerkmeanx tbodyaccjerkmeany tbodyaccjerkmeanz tbodyaccjerkstdx
    ## 1        0.07204601         0.0457544        -0.1060427       -0.9066828
    ##   tbodyaccjerkstdy tbodyaccjerkstdz
    ## 1       -0.9380164       -0.9359358

    nrow(tidy_test)

    ## [1] 2947

Milestone 3: Merging Training and Test Data
===========================================

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
    tidy_temp[1, 1:20]

    ##   subjectid tbodyaccmeanx tbodyaccmeany tbodyaccmeanz tbodyaccstdx
    ## 1         1     0.2778302   -0.01768405    -0.1057035   -0.9961431
    ##   tbodyaccstdy tbodyaccstdz tgravityaccmeanx tgravityaccmeany
    ## 1   -0.9959687   -0.9948886       -0.2070261        0.7696283
    ##   tgravityaccmeanz tgravityaccstdx tgravityaccstdy tgravityaccstdz
    ## 1        0.5921923       -0.998868      -0.9977816        -0.99647
    ##   tbodyaccjerkmeanx tbodyaccjerkmeany tbodyaccjerkmeanz tbodyaccjerkstdx
    ## 1        0.07449279        0.01542188       0.004916667       -0.9933154
    ##   tbodyaccjerkstdy tbodyaccjerkstdz tbodygyromeanx
    ## 1       -0.9944629       -0.9927844    -0.02818969

    nrow(tidy_temp)

    ## [1] 10299

Milestone 4: Createing Tidy Data set with the Average of each variable for each Activity and each Subject
=========================================================================================================

    tidy_group <- group_by (tidy, subject_id, activity_labels)
    tidy_group %>% group_by (subject_id, activity_labels) %>% summarise_each(funs(mean)) -> tidy_aggregate

    ## `summarise_each()` is deprecated.
    ## Use `summarise_all()`, `summarise_at()` or `summarise_if()` instead.
    ## To map `funs` over all variables, use `summarise_all()`

    tidy_aggregate <- arrange (tidy_aggregate, subject_id, activity_labels)
    tidy_aggregate <- dplyr::rename(tidy_aggregate, subjectid = subject_id, activitylabels = activity_labels)
    tidy_aggregate[1:50, 1:5]

    ## # A tibble: 50 x 5
    ## # Groups:   subjectid [9]
    ##    subjectid     activitylabels tbodyaccmeanx tbodyaccmeany tbodyaccmeanz
    ##        <int>              <chr>         <dbl>         <dbl>         <dbl>
    ##  1         1             LAYING     0.2215982  -0.040513953    -0.1132036
    ##  2         1            SITTING     0.2612376  -0.001308288    -0.1045442
    ##  3         1           STANDING     0.2789176  -0.016137590    -0.1106018
    ##  4         1            WALKING     0.2773308  -0.017383819    -0.1111481
    ##  5         1 WALKING_DOWNSTAIRS     0.2891883  -0.009918505    -0.1075662
    ##  6         1   WALKING_UPSTAIRS     0.2554617  -0.023953149    -0.0973020
    ##  7         2             LAYING     0.2813734  -0.018158740    -0.1072456
    ##  8         2            SITTING     0.2770874  -0.015687994    -0.1092183
    ##  9         2           STANDING     0.2779115  -0.018420827    -0.1059085
    ## 10         2            WALKING     0.2764266  -0.018594920    -0.1055004
    ## # ... with 40 more rows

    nrow(tidy_aggregate)

    ## [1] 180

Milestone 5: Saving Results to a File
=====================================

    save_output <- function (frame, file = "output.csv") {
            write.table(frame, 
                        file = file,
                        sep = ",",
                        col.names = TRUE,
                        row.names = FALSE
            )
    }
    save_output(tidy_aggregate, "tidy_aggregate.csv")

Milestone 6: Computing Exection Time
====================================

    timeEnd <- Sys.time()
    timeTask <- round (as.numeric(timeEnd - timeStart), 2)
    print (paste0("Execution time for processing ", nrow(tidy), " rows is ", timeTask, " seconds"))

    ## [1] "Execution time for processing 10299 rows is 1.72 seconds"
