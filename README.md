# ProgrammingAssignment4
Programming Assignment for combining and tidying traing and testing data sets of Samsung phones

## Functions Description
### run_analysis
This is the main function of the script. It reads the training and testing data sets and combine them into one data set and generates a new tidy data set

### getAllFeatures
This function can read all the features(variables) from the features.txt and extract only the mean and std across all the measurements

### getDataSet
This function can read the main training/testing data sets(X) and add the subjects data as well as the labels(activities) data(y)

### createNewDataset
create a new tidy data set to calculate the average values for each subject and each activity