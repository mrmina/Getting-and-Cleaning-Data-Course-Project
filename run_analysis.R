# STEP Zero: Load libriries, and download/extract data files

# load requierd libraries
library(dplyr)

# SETTINGS
# this variable include the data sources and directory path to the data.
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCIDataset.zip"
data_dir <- "./"
data.features.file <- "./UCI HAR Dataset/features.txt"
data.test.dir <- "./UCI HAR Dataset/test/"
data.train.dir <- "./UCI HAR Dataset/train/"
data.activity_labels <- "./UCI HAR Dataset/activity_labels.txt"
finalTidyDataFilename <- "final.tidy.data.csv"

# check if we have the data archive to be processed.
# if not, download it the current directory
if (!file.exists(zipFile)){download.file(zipURL, zipFile)}

# if the archice weren't extracted before, then extract it
# you can check on all the files to be processed if you want.
if (!dir.exists(data.test.dir)) {unzip(zipFile, exdir = data_dir)}

# LOAD DATA FILE:
# Load features file (field names)
features <- read.table(data.features.file)

#Load activity labels (it is a translation label for the activity codes)
activity_labels <- read.table(data.activity_labels)

# Load training data
X_train <- read.table(paste0(data.train.dir,"X_train.txt"))
y_train <- read.table(paste0(data.train.dir,"y_train.txt"))
subject_train <- read.table(paste0(data.train.dir,"subject_train.txt"))

# Load testing data 
X_test <- read.table(paste0(data.test.dir,"X_test.txt"))
y_test <- read.table(paste0(data.test.dir,"y_test.txt"))
subject_test <- read.table(paste0(data.test.dir,"subject_test.txt"))

# STEP ONE: Merges the training and the test sets to create one data set.

# Merge the testing and training data into one data frame (X_all)
# and delete old data frames to save space
X_all <- rbind(X_train, X_test)
rm(X_train)
rm(X_test)

# Merge the testing and training data into one data frame (y_all)
# and delete old data frames to save space
y_all <- rbind(y_train, y_test)
names(y_all) <- c("y") # set name of the column
rm(y_train)
rm(y_test)

# Merge the testing and training data os SUBJECTS into one data frame
# (subject_all) and delete old data frames to save space
subject_all <- rbind(subject_train, subject_test)
rm(subject_train)
rm(subject_test)


# STEP TWO: Extracts only the measurements on the mean and standard
# deviation for each measurement.

# filter out all the features/fields that has the word mean or std using greo
featuresNeeded <- features[grep("mean|std",features$V2),]

# Extract columns with mean and standard deviation in the names.
X_final <- X_all[,featuresNeeded$V1]
rm(X_all)

# STEP THREE: Uses descriptive activity names to name the activities in the data set
# we will convert the y column form int to factor, and label the level of
# the factors to become more understandable. The level labels that will be
# used was previously loaded and stored in activity_labels
y_all$y <- factor(y_all$y, labels = activity_labels$V2)


#STEP FOUR: Appropriately labels the data set with descriptive variable names.
# Set the column names to be 
names(X_final) <- featuresNeeded$V2
names(subject_all) <- c("subject")
names(y_all) <- c("y") # set name of the column
dataMergedFinal <- cbind(subject_all, y_all, X_final)
rm(features, featuresNeeded,subject_all, X_final,y_all, activity_labels)

# STEP FIVE: creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
dataSummary <- dataMergedFinal %>% group_by(subject,y) %>% summarise_each(funs(mean))


# STEP SIX (OPTIONAL): write cleaned raw data and summarised data to CSV for further analysis
output_file <- paste0("./raw_",finalTidyDataFilename)
write.csv(dataMergedFinal, file = output_file)
print(paste("Tidy RAW data has been saved in:", output_file))

output_file <- paste0("./summary(avgAllColumns)_",finalTidyDataFilename)
write.csv(dataSummary, file = output_file)
print(paste("Tidy SUMMARIZED data has been saved in:", output_file))
