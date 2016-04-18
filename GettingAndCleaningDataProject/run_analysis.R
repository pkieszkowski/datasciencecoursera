
# Create new subfolder
if (!getwd() == "./GettingAndCleaningDataProject") {
  dir.create("./GettingAndCleaningDataProject")
}
rm(list = ls(all = TRUE))

# Load libraries

library(plyr) # load plyr  
library(dplyr) # load dplyr 
library(data.table) # load data.table

# Download Zip File

temp <- tempfile() # Create a temp file
URL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = temp) # Download Zip file to the Temp File

# Load Zip File into tables

unzip(temp, list = TRUE) # List files that we will use in  the project
y_test <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
X_test <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
subject_test <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
y_train <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
X_train <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
subject_train <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
unlink(temp) # Remove the temp file via unlink()

colnames(X_train) <- t(features[2])
colnames(X_test) <- t(features[2])

X_train$activities <- y_train[, 1]
X_train$participants <- subject_train[, 1]
X_test$activities <- y_test[, 1]
X_test$participants <- subject_test[, 1]

# Part 1

data <- rbind(X_train, X_test)
duplicated(colnames(data))
data <- data[, !duplicated(colnames(data))]

head(data,5)

# Part 2

Mean <- grep("mean()", names(data), value = FALSE, fixed = TRUE)
#In addition, we need to include 555:559 as they have means and are associated with the gravity terms
Mean <- append(Mean, 471:477)
InstrumentMeanMatrix <- data[Mean]
# For STD
STD <- grep("std()", names(data), value = FALSE)
InstrumentSTDMatrix <- data[STD]

Mean
STD
head(InstrumentSTDMatrix, 5)

# Part 3

data$activities <- as.character(data$activities)
data$activities[data$activities == 1] <- "Walking"
data$activities[data$activities == 2] <- "Walking Upstairs"
data$activities[data$activities == 3] <- "Walking Downstairs"
data$activities[data$activities == 4] <- "Sitting"
data$activities[data$activities == 5] <- "Standing"
data$activities[data$activities == 6] <- "Laying"
data$activities <- as.factor(data$activities)

head(data,5)

# Part 4
names(data)  # review data variables

names(data) <- gsub("Acc", "Accelerator", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))

data$participants <- as.character(data$participants)
data$participants[data$participants == 1] <- "Participant 1"
data$participants[data$participants == 2] <- "Participant 2"
data$participants[data$participants == 3] <- "Participant 3"
data$participants[data$participants == 4] <- "Participant 4"
data$participants[data$participants == 5] <- "Participant 5"
data$participants[data$participants == 6] <- "Participant 6"
data$participants[data$participants == 7] <- "Participant 7"
data$participants[data$participants == 8] <- "Participant 8"
data$participants[data$participants == 9] <- "Participant 9"
data$participants[data$participants == 10] <- "Participant 10"
data$participants[data$participants == 11] <- "Participant 11"
data$participants[data$participants == 12] <- "Participant 12"
data$participants[data$participants == 13] <- "Participant 13"
data$participants[data$participants == 14] <- "Participant 14"
data$participants[data$participants == 15] <- "Participant 15"
data$participants[data$participants == 16] <- "Participant 16"
data$participants[data$participants == 17] <- "Participant 17"
data$participants[data$participants == 18] <- "Participant 18"
data$participants[data$participants == 19] <- "Participant 19"
data$participants[data$participants == 20] <- "Participant 20"
data$participants[data$participants == 21] <- "Participant 21"
data$participants[data$participants == 22] <- "Participant 22"
data$participants[data$participants == 23] <- "Participant 23"
data$participants[data$participants == 24] <- "Participant 24"
data$participants[data$participants == 25] <- "Participant 25"
data$participants[data$participants == 26] <- "Participant 26"
data$participants[data$participants == 27] <- "Participant 27"
data$participants[data$participants == 28] <- "Participant 28"
data$participants[data$participants == 29] <- "Participant 29"
data$participants[data$participants == 30] <- "Participant 30"
data$participants <- as.factor(data$participants)

# Part 5

data.dt <- data.table(data)
tidydata <- data.dt[, lapply(.SD, mean), by = 'participants,activities']
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)

head(tidydata,5)


