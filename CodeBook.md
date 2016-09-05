# CodeBook


## STEP Zero: Load libriries, and download/extract data files

Load requierd libraries


```r
library(dplyr)
```

**SETTINGS**

These variables include the data sources and directory path to the data.


```r
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCIDataset.zip"
data_dir <- "./"
data.features.file <- "./UCI HAR Dataset/features.txt"
data.test.dir <- "./UCI HAR Dataset/test/"
data.train.dir <- "./UCI HAR Dataset/train/"
data.activity_labels <- "./UCI HAR Dataset/activity_labels.txt"
finalTidyDataFilename <- "final.tidy.data.csv"
```

check if we have the data archive to be processed. If not, download it the current directory


```r
if (!file.exists(zipFile)){download.file(zipURL, zipFile)}
```

if the archive weren't extracted before, then extract it you can check on all the files to be processed if you want.


```r
if (!dir.exists(data.test.dir)) {unzip(zipFile, exdir = data_dir)}
```

**LOAD DATA FILES**

```r
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
```



## STEP ONE: Merges the training and the test sets to create one data set.

Merge the testing and training data into one data frame (X_all) and delete old data frames to save space

```r
X_all <- rbind(X_train, X_test)
rm(X_train)
rm(X_test)
```


Merge the testing and training data into one data frame (y_all) and delete old data frames to save space

```r
y_all <- rbind(y_train, y_test)
names(y_all) <- c("y") # set name of the column
rm(y_train)
rm(y_test)
```


Merge the testing and training data os SUBJECTS into one data frame (subject_all) and delete old data frames to save space

```r
subject_all <- rbind(subject_train, subject_test)
rm(subject_train)
rm(subject_test)
```



## STEP TWO: Extracts only the measurements on the mean and standard deviation for each measurement.

The field names/feature names the include mean or standard deviation (std) will be extracted using the grep function. The indices returned by the greo function will be used to extract those columns.


```r
# filter out all the features/fields that has the word mean or std using greo
featuresNeeded <- features[grep("mean|std",features$V2),]

# Extract columns with mean and standard deviation in the names.
X_final <- X_all[,featuresNeeded$V1]
rm(X_all)
```



## STEP THREE: Uses descriptive activity names to name the activities in the data set

we will convert the y column form int to factor, and label the level of the factors to become more understandable. The level labels that will be used was previously loaded and stored in activity_labels

```r
y_all$y <- factor(y_all$y, labels = activity_labels$V2)
```



## STEP FOUR: Appropriately labels the data set with descriptive variable names.

We will make sure that all columns are labeled with their correponding variable names.


```r
names(X_final) <- featuresNeeded$V2
names(subject_all) <- c("subject")
names(y_all) <- c("y") # set name of the column
dataMergedFinal <- cbind(subject_all, y_all, X_final)
rm(features, featuresNeeded,subject_all, X_final,y_all, activity_labels)
```



## STEP FIVE: creates a second, independent tidy data set with the average of  each variable for each activity and each subject.

The dplyr library is used to group by the dataset by subjects and activities (y variable), then we will calculate the mean for all variable using the summarise_each function.


```r
dataSummary <- dataMergedFinal %>% group_by(subject,y) %>% summarise_each(funs(mean))
```



## STEP SIX: write cleaned raw data and summarised data to CSV for further analysis

Save the cleaned **SUMMARISED** data, for furthe furure processing

**Note: This is output file required by the assignment**


```r
output_file <- paste0("./summary(avgAllColumns)_",finalTidyDataFilename)
write.csv(dataSummary, file = output_file)
print(paste("Tidy SUMMARIZED data has been saved in:", output_file))
```

```
## [1] "Tidy SUMMARIZED data has been saved in: ./summary(avgAllColumns)_final.tidy.data.csv"
```


Save the cleaned **raw** data, for furthe furure analysis (OPTIONAL)

Note: This is output file wasn't required by the assignment **optional**


```r
output_file <- paste0("./raw_",finalTidyDataFilename)
write.csv(dataMergedFinal, file = output_file)
print(paste("Tidy RAW data has been saved in:", output_file))
```

```
## [1] "Tidy RAW data has been saved in: ./raw_final.tidy.data.csv"
```
