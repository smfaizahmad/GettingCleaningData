#Setting up working directory to where the data set is located
setwd("E:/DataSciences/RWD")

#reading training data set
training = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

#reading testing data set
testing = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

#Labeling all activities
act_Label = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Read features and make the feature names better suited for R with some substitutions
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Merge training and testing data set
bothdata = rbind(training, testing)

# filter data on mean and standard deviation
reqdcols <- grep(".*Mean.*|.*Std.*", features[,2])

# reducing features to the required data set
features <- features[reqdcols,]

# Adding subject and activity
reqdcols <- c(reqdcols, 562, 563)

# removing data which is not required
bothdata <- bothdata[,reqdcols]

# Adding column names to bothdata
colnames(bothdata) <- c(features$V2, "Activity", "Subject")
colnames(bothdata) <- tolower(colnames(bothdata))

currentActivity = 1
for (currentActivityLabel in act_label$V2) {
  bothdata$activity <- gsub(currentActivity, currentActivityLabel, bothdata$activity)
  currentActivity <- currentActivity + 1
}

bothdata$activity <- as.factor(bothdata$activity)
bothdata$subject <- as.factor(bothdata$subject)

tidy_data_set = aggregate(bothdata, by=list(activity = bothdata$activity, subject=bothdata$subject), mean)

# Remove the subject and activity column, since a mean of those has no use
tidy_data_set[,90] = NULL
tidy_data_set[,89] = NULL
write.table(tidy_data_set, "tidy_data_set.txt", sep="\t")
