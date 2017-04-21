# clean global environment
rm(list = ls())

## Download and unzip the dataset:
if ((!file.exists("getdata_dataset.zip")) && (!file.exists("UCI HAR Dataset"))){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, "getdata_dataset.zip", method="curl")
}
if (!file.exists("UCI HAR Dataset")) {
  unzip("getdata_dataset.zip")
}

# load useful library
library(reshape2)
library(dplyr)

# load the train and test datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# load activity labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityNum", "activityLabel"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("featureNum", "featureLabel"))

# extract only the data on mean and standard deviation
featuresWanted <- features[grep("mean\\(\\)|std\\(\\)", features$featureLabel),]

train <- train[,featuresWanted$featureNum]
train <- cbind(trainSubjects, trainActivities, train)

test <- test[,featuresWanted$featureNum]
test <- cbind(testSubjects, testActivities, test)

# merge datasets
df.merged <- rbind(train, test)
colnames(df.merged) <- c("subject", "activity", as.character(featuresWanted$featureLabel))

# turn activities & subjects into factors
df.merged$activity <- factor(df.merged$activity, levels = activityLabels$activityNum, labels = activityLabels$activityLabel)
df.merged$subject <- as.factor(df.merged$subject)

# Make clearer names
names(df.merged) <- gsub('Acc',"Acceleration",names(df.merged))
names(df.merged) <- gsub('GyroJerk',"AngularAcceleration",names(df.merged))
names(df.merged) <- gsub('Gyro',"AngularSpeed",names(df.merged))
names(df.merged) <- gsub('Mag',"Magnitude",names(df.merged))
names(df.merged) <- gsub('^t',"TimeDomain.",names(df.merged))
names(df.merged) <- gsub('^f',"FrequencyDomain.",names(df.merged))
names(df.merged) <- gsub('\\.mean',".Mean",names(df.merged))
names(df.merged) <- gsub('\\.std',".StandardDeviation",names(df.merged))
names(df.merged) <- gsub('Freq\\.',"Frequency.",names(df.merged))
names(df.merged) <- gsub('Freq$',"Frequency",names(df.merged))

# creates a tidy data set with the average of each variable for each activity and each subject
tidy.data <- df.merged %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(tidy.data, file = "sensor_avg_by_act_sub.txt")