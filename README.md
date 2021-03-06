# JHU: Getting and Cleaning Data Course Project

## Introduciton
This repo is part of the Data Cleaning course at JHU. The repo include an R script that downloads and reads sensor data caputured by UCI. The data analyzed represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The script in this repo reads the training and testing data captured by this research and performs the following:

- Merges the training and the test sets to create one data set.

- Extracts only the measurements on the mean and standard deviation for each measurement.

- Uses descriptive activity names to name the activities in the data set

- Appropriately labels the data set with descriptive variable names.

- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Files
- run_analysis.R: An R script that downloads the research data, does the necessary data processing and merges the testing and trainig datasets. it also outputs two files: summary of all variables for each subject per activity and saves the raw cleaned data processed by this script, for future use. 

- CodeBook.md : a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data.

- UCIDataset.zip: the original dataset that has the raw data.

- summarized.tidy.data.txt: A text file that contains a tidy data set with the average of each variable for each activity per subject.
