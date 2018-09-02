# CODE BOOK
## Getting and Cleaning Data Course Project - COURSERA

This code book describes the transformation process on the `run_analysis.R`.
The final result is the space-delimited file `tidy_data_set.txt`.

## Data
Input files: `subject_test`, `subject_train`, `x_test`, `y_test`, `x_train`, `y_train`.

### Variables

__Subject__: identifies the subject of the test [range: 1-30].

__Activity__: `LAYING`, `SITTING`, `STANDING`, `WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`.

__Measurements__: float-point values [range: -1,1]

The measurements selected for this database come from the accelerometer and gyroscope 3-axial raw signals `timeAcc-XYZ` and `timeGyro-XYZ`. 
These time domain signals (prefix 'time') were captured at a constant rate of 50 Hz. 
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. 

Similarly, the acceleration signal was then separated into body and gravity acceleration signals (`timeBodyAcc-XYZ` and `timeGravityAcc-XYZ`) using 
another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (`timeBodyAccJerk-XYZ` and 
`timeBodyGyroJerk-XYZ`). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (`timeBodyAccMag`, 
`timeGravityAccMag`, `timeBodyAccJerkMag`, `timeBodyGyroMag`, `timeBodyGyroJerkMag`). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing `freqBodyAcc-XYZ`, `freqBodyAccJerk-XYZ`, `freqBodyGyro-XYZ`, 
`freqBodyAccJerkMag`, `freqBodyGyroMag`, `freqBodyGyroJerkMag`.

Only the `mean()` and `std()` measurements are kept.


## Transformation
1. The path for the extracted zip source file is checked. If not found, the .zip is donwloaded into the working directory and extracted.

2. All the necessary files for the project are read into data frames. 
	
3. The training and test data sets are merged, by the table information. This creates a data set for x, y and subject.The function used is `rbind()`.
	
4. Using regex, we identify the columns with mean `mean()` or standard deviation `std()` in the column name, in the x data set.

5. Then we subset the x data frame to keep only the columns identified in item 4.

6. We name the only variable in y data frame as "activity", and the only variable in the subject data frame as "subject".

7. The data frames are merged using the `cbind()` function. 

8. The averages are generated, grouped by subject and activity.

9. Special chars are replaced and variables have names changed to more readble ones.

10. The tidy data is exported as `tidy_data_set.txt` in the working directory.