CookBook
========

## Introduction

The script `run_analysis.R` performs the 5 steps described in the course project's definition.

First, only those columns with the mean and standard deviation measures are taken from the whole dataset. We extract features with `mean()` or `std()` in their names taken from `features.txt`. After extracting these columns, we merge train and test data sets using `cbind()` and `rbind()`. We give correct names to each columns.

Finally, we create a tidy data set with the average of each variable for each activity and each subject and save the result in the `sensor_avg_by_act_sub.txt` file using the `dplyr` package.

## sensor_avg_by_act_sub.txt

This part summarizes the resulting in `sensor_avg_by_act_sub.txt`.

### Identifiers

* `subject` - The ID of the test subject
* `activity` - The type of activity performed

### Activity Labels

`WALKING` (value `1`): walking during the test
`WALKING_UPSTAIRS` (value `2`): walking up a staircase during the test
`WALKING_DOWNSTAIRS` (value `3`): walking down a staircase during the test
`SITTING` (value `4`): sitting during the test
`STANDING` (value `5`): standing during the test
`LAYING` (value `6`): laying down during the test

### Variables

* `TimeDomain.BodyAcceleration-mean()-X`
* `TimeDomain.BodyAcceleration-mean()-Y`
* `TimeDomain.BodyAcceleration-mean()-Z`
* `TimeDomain.BodyAcceleration-std()-X`
* `TimeDomain.BodyAcceleration-std()-Y`
* `TimeDomain.BodyAcceleration-std()-Z`
* `TimeDomain.GravityAcceleration-mean()-X`
* `TimeDomain.GravityAcceleration-mean()-Y`
* `TimeDomain.GravityAcceleration-mean()-Z`
* `TimeDomain.GravityAcceleration-std()-X`
* `TimeDomain.GravityAcceleration-std()-Y`
* `TimeDomain.GravityAcceleration-std()-Z`
* `TimeDomain.BodyAccelerationJerk-mean()-X`
* `TimeDomain.BodyAccelerationJerk-mean()-Y`
* `TimeDomain.BodyAccelerationJerk-mean()-Z`
* `TimeDomain.BodyAccelerationJerk-std()-X`
* `TimeDomain.BodyAccelerationJerk-std()-Y`
* `TimeDomain.BodyAccelerationJerk-std()-Z`
* `TimeDomain.BodyAngularSpeed-mean()-X`
* `TimeDomain.BodyAngularSpeed-mean()-Y`
* `TimeDomain.BodyAngularSpeed-mean()-Z`
* `TimeDomain.BodyAngularSpeed-std()-X`
* `TimeDomain.BodyAngularSpeed-std()-Y`
* `TimeDomain.BodyAngularSpeed-std()-Z`
* `TimeDomain.BodyAngularAcceleration-mean()-X`
* `TimeDomain.BodyAngularAcceleration-mean()-Y`
* `TimeDomain.BodyAngularAcceleration-mean()-Z`
* `TimeDomain.BodyAngularAcceleration-std()-X`
* `TimeDomain.BodyAngularAcceleration-std()-Y`
* `TimeDomain.BodyAngularAcceleration-std()-Z`
* `TimeDomain.BodyAccelerationMagnitude-mean()`
* `TimeDomain.BodyAccelerationMagnitude-std()`
* `TimeDomain.GravityAccelerationMagnitude-mean()`
* `TimeDomain.GravityAccelerationMagnitude-std()`
* `TimeDomain.BodyAccelerationJerkMagnitude-mean()`
* `TimeDomain.BodyAccelerationJerkMagnitude-std()`
* `TimeDomain.BodyAngularSpeedMagnitude-mean()`
* `TimeDomain.BodyAngularSpeedMagnitude-std()`
* `TimeDomain.BodyAngularAccelerationMagnitude-mean()`
* `TimeDomain.BodyAngularAccelerationMagnitude-std()`
* `FrequencyDomain.BodyAcceleration-mean()-X`
* `FrequencyDomain.BodyAcceleration-mean()-Y`
* `FrequencyDomain.BodyAcceleration-mean()-Z`
* `FrequencyDomain.BodyAcceleration-std()-X`
* `FrequencyDomain.BodyAcceleration-std()-Y`
* `FrequencyDomain.BodyAcceleration-std()-Z`
* `FrequencyDomain.BodyAccelerationJerk-mean()-X`
* `FrequencyDomain.BodyAccelerationJerk-mean()-Y`
* `FrequencyDomain.BodyAccelerationJerk-mean()-Z`
* `FrequencyDomain.BodyAccelerationJerk-std()-X`
* `FrequencyDomain.BodyAccelerationJerk-std()-Y`
* `FrequencyDomain.BodyAccelerationJerk-std()-Z`
* `FrequencyDomain.BodyAngularSpeed-mean()-X`
* `FrequencyDomain.BodyAngularSpeed-mean()-Y`
* `FrequencyDomain.BodyAngularSpeed-mean()-Z`
* `FrequencyDomain.BodyAngularSpeed-std()-X`
* `FrequencyDomain.BodyAngularSpeed-std()-Y`
* `FrequencyDomain.BodyAngularSpeed-std()-Z`
* `FrequencyDomain.BodyAccelerationMagnitude-mean()`
* `FrequencyDomain.BodyAccelerationMagnitude-std()`
* `FrequencyDomain.BodyBodyAccelerationJerkMagnitude-mean()`
* `FrequencyDomain.BodyBodyAccelerationJerkMagnitude-std()`
* `FrequencyDomain.BodyBodyAngularSpeedMagnitude-mean()`
* `FrequencyDomain.BodyBodyAngularSpeedMagnitude-std()`
* `FrequencyDomain.BodyBodyAngularAccelerationMagnitude-mean()`
* `FrequencyDomain.BodyBodyAngularAccelerationMagnitude-std()`
