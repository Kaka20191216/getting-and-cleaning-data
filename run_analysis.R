library(reshape2)
filename <- "wearable.zip"

## download dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,filename)

##unzip file
if(!file.exists("UCI HAR Dataset")){unzip(filename)}

##read activity lables and features, store them
features <- read.table("UCI HAR Dataset/features.txt",col.names = c("n","features"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("label", "activity"))

## mean and st extraction
featuresExtracted <- grep(".*mean.*|.*std.*", features[,2])
featuresExtracted_name <- features[features2,2]
featuresExtracted_name <- gsub('-mean','Mean', featuresExtracted_name)
featuresExtracted_name <- gsub('-std','Std', featuresExtracted_name)
##featuresExtracted_name <- gsub('[-()]','\\', featuresExtracted_name)

traindata <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresExtracted]
trainlable <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjectrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subjectrain, trainlable, traindata)

testdata <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresExtracted]
testlabel <- read.table("UCI HAR Dataset/test/Y_test.txt")
subjectest <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subjectest, testlabel, testdata)

mydata <- rbind(train, test)
colnames(mydata) <- c("Subject","Activity",featuresExtracted_name)

mydata$Subject <- as.factor(mydata$Subject)
mydata$Activity <- factor(mydata$Activity, levels = activities[,1], labels = activities[,2])

## create tidy dataset
melted <- melt(mydata, id = c("Subject","Activity"))
mydata2 <- dcast(melted, Subject + Activity ~ variable, mean)

## save new file
write.table(mydata2, "wearable2.txt", row.names = FALSE, quote = FALSE)
