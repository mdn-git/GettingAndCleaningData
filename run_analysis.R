###############################################################################################################
###                     Getting and Cleaning Data Course Project                                            ###
###                                                                                                         ###
### 1. Merges the training and the test sets to create one data set.                                        ###
### 2. Extracts only the measurements on the mean and standard deviation for each measurement.              ###
### 3. Uses descriptive activity names to name the activities in the data set                               ###
### 4. Appropriately labels the data set with descriptive variable names.                                   ###
### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each    ###
###    variable for each activity and each subject.                                                         ###
###############################################################################################################

###############################################################################################################
###     LIBS                                                                                                 ##
###############################################################################################################
library(dplyr)

###############################################################################################################
###     FILE IMPORT                                                                                          ##
###############################################################################################################

# set the zipfile properties
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipName <- "UCI_HAR_Dataset.zip"
zipPath <- "UCI HAR Dataset"

#Verifiy if the zip was already extracted
if (!file.exists(zipPath)) {
  
  #path doesn't exist. Verify if the .zip file exists in the working directory
  if (!file.exists(zipName)) {
    
    # Download as binary
    download.file(fileUrl, zipName, mode = "wb")
  
  }
  
  #extract the zip file 
  unzip(zipName)

}

###############################################################################################################
###     READ FILES                                                                                           ##
###############################################################################################################

#read the data tables, using platform-independent way file.path
#features
dt_features <- read.table(file.path(zipPath, "features.txt"))

#activities
dt_activities <- read.table(file.path(zipPath, "activity_labels.txt"))

#UCI HAR DATASET\train
dt_train_subject <- read.table(file.path(zipPath, "train", "subject_train.txt"))
dt_train_x <- read.table(file.path(zipPath, "train", "x_train.txt"))
dt_train_y <- read.table(file.path(zipPath, "train", "y_train.txt"))

#UCI HAR DATASET\test
dt_test_subject <- read.table(file.path(zipPath, "test", "subject_test.txt"))
dt_test_x <- read.table(file.path(zipPath, "test", "x_test.txt"))
dt_test_y <- read.table(file.path(zipPath, "test", "y_test.txt"))


###############################################################################################################
###     DATA TRANSFORMATION                                                                                  ##
###############################################################################################################

#union test and train data sets
dt_x <- rbind(dt_train_x, dt_test_x)
dt_y <- rbind(dt_train_y, dt_test_y)
dt_subjects <- rbind(dt_train_subject, dt_test_subject)

# get only columns with mean() or std() in their names
colIndex_mean_std <- grep("-(mean|std)\\(\\)", dt_features[, 2])

#subset to keep only the variables with mean() or std() in the name 
dt_x <- dt_x[, colIndex_mean_std]

#replace the column names of dt_x
names(dt_x) <- dt_features[colIndex_mean_std, 2]

#replace the activities id with the appropriate label
dt_y[, 1] <- dt_activities[dt_y[, 1], 2]

#replace the name of the only column of dt_y as activity
names(dt_y) <- "activity"

# replace the name of the only column of dt_subject as subject
names(dt_subjects) <- "subject"

# union all data sets 
dt_all <- cbind(dt_x, dt_y, dt_subjects)

#create the average
dt_average <- dt_all %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

###############################################################################################################
###     NAMES ADJUSTMENTS                                                                                    ##
###############################################################################################################

#get all columns names
dt_average_columns_names <- colnames(dt_average)

#remove - ( )
dt_average_columns_names <- gsub("[\\(\\)-]", "", dt_average_columns_names)

#descriptive names
dt_average_columns_names <- gsub("^f", "freq", dt_average_columns_names)
dt_average_columns_names <- gsub("^t", "time", dt_average_columns_names)

#put first letter in capital
dt_average_columns_names <- gsub("mean", "Mean", dt_average_columns_names)
dt_average_columns_names <- gsub("std", "Std", dt_average_columns_names)

# replace the names
colnames(dt_average) <- dt_average_columns_names

###############################################################################################################
###     PROCESSED FILE EXPORT                                                                                ##
###############################################################################################################

write.table(dt_average, "tidy_data_set.txt", row.name=FALSE)