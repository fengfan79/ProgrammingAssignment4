run_analysis <- function() {
  #get all the features
  features <- getAllFeatures();
  
  #get the features only measures mean and std
  index_features <- getSelectedIndex(features)
  selFeatures <- features[index_features]
  
  #get training data and testing data
  dsTrain <- getDataSet(features, index_features, type = "train")
  dsTest <- getDataSet(features, index_features, type = "test")
  
  #merge the training data and testing data
  dsMerged <- rbind(dsTrain, dsTest)
  
  #tidy the variable names
  names(dsMerged)[2:length(dsMerged)] <- tidyVariables(names(dsMerged)[2:length(dsMerged)])
  
  #create a new tidy data set
  dfNewTidy <- createNewDataset(dsMerged)
  
  #write the data into a txt file
  write.table(dfNewTidy, "phone_activities.txt", row.names = FALSE)
}

#get all the features from features.txt
getAllFeatures <- function(datasetFolder = "Dataset") {
  #read features dataset from features.txt
  features <- read.table(paste(datasetFolder, "features.txt", sep = "/"), sep = " ")
  features <- features[, 2]
  
  #convert features data frame to characters
  features <- as.character(features)
  
  features
}

#labels the data set with descriptive variable names
tidyVariables <- function(features) {
  features <- sub(".std..", "StandardDeviation", features)
  features <- sub(".mean..", "Mean", features)
  features <- sub("^t", "Time", features)
  features <- sub("^f", "Frenquency", features)
  features <- sub("Acc", "Acceleration", features)
  features <- sub("Mag", "Magnitude", features)
  features <- sub("\\.", "", features)
  
  features
}

#name the activities
tidyActivities <- function(activities) {
  actualActivities <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
  activities <- actualActivities[activities[ , ]]
  
  activities
}

#get the index of features that measure the mean and std
getSelectedIndex <- function(features) {
  #get the index of all the mean measurements
  index_features_mean <- grep("mean()", features, fixed = TRUE)
  
  #get the index of all the std measurement
  index_features_std <- grep("std()", features, fixed = TRUE)
  
  #conbine the two index vector and sort it
  index_features <- c(index_features_mean, index_features_std)
  index_features <- sort(index_features)
  
  index_features
}

getDataSet <- function(features, indexFeatures, type = "train", datasetFolder = "Dataset") {
  type = {
    if (type == "train") {
      "train"
    } else {
      "test"
    }
    
    #read all subjects
    subjects <- read.table(paste(datasetFolder, "/", type, "/subject_", type, ".txt", sep = ""),
                           col.names = "VolunteerNumber")
    
    #read data set and select specified columns
    dataset <- read.table(paste(datasetFolder, "/", type, "/X_", type, ".txt", sep = ""), 
                          col.names = features)
    dataset <- dataset[, indexFeatures]
    
    #read labels (activities)
    activities <- read.table(paste(datasetFolder, "/", type, "/y_", type, ".txt", sep = ""),
                        col.names = "Activity")
    activities <- tidyActivities(activities)
    
    #bind the subjects, data set and labels
    cbind(subjects, dataset, activities)
  }
}

createNewDataset <- function(dsMerged) {
  dsNewTidy <- aggregate(dsMerged[, 2:67], by=list(dsMerged$VolunteerNumber, dsMerged$activities), FUN = mean, drop = TRUE)
  names(dsNewTidy)[1] = "VolunteerNumber"
  names(dsNewTidy)[2] = "Activity"
  
  dsNewTidy
}

