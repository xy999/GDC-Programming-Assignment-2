#------------------------------------------------------------------
# Getting and Cleaning Data Course Project

# run_Analysis.r File Description

# The code in this file performs the following functions:

# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#---------------------
#    Step 1: Merges the training and the test sets to create one data set.
#---------------------

setwd("INSERT YOUR WD HERE; EXCLUDED FOR SUBMISSION PURPOSES")

#----Training Data----

#load training data and label columns
feat <- read.table("features.txt")
nlist <- as.vector(feat$V2)
x.train <- read.table("./train/X_train.txt", sep = "", col.names = nlist) 

#read in Individual ID and Activity and merge them
activity <- read.table("./train/y_train.txt", col.names = c("Activity"))
subj.id <- read.table("./train/subject_train.txt", col.names = c("Subj.ID"))
subj.act <- cbind(subj.id, activity)

#create data frame to use for marking this as the Training Group
group <- data.frame(rep("Train", times = nrow(x.train)))
names(group)[1] <- "Group"

#bind elements created thus far
dat.train <- cbind(group, subj.act, x.train)

#----Test Data----

#load test data and label columns
x.test <- read.table("./test/X_test.txt", sep = "", col.names = nlist) 

#read in Individual ID and Activity and merge them
activity.te <- read.table("./test/y_test.txt", col.names = c("Activity"))
subj.id.te <- read.table("./test/subject_test.txt", col.names = c("Subj.ID"))
subj.act.te <- cbind(subj.id.te, activity.te)

#create data frame marking this as the Training Group
group.te <- data.frame(rep("Test", times = nrow(x.test)))
names(group.te)[1] <- "Group"

#bind elements created thus far
dat.test <- cbind(group.te, subj.act.te, x.test)

#----Master Dataset----

#merge training and test dataset to create a master dataset
dat <- rbind(dat.train, dat.test)

#---------------------
#    Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#---------------------

#subset data to only keep mean and std measurements
dat.ids <- dat[, 1:3]
mean.cols <- grep("mean", colnames(dat), ignore.case = TRUE)
std.cols <- grep("std", colnames(dat), ignore.case = TRUE)
cols.list <- sort(c(mean.cols, std.cols))
dat.mean.std <- dat[cols.list]
dat.sub <- cbind(dat.ids, dat.mean.std)

#---------------------
#    Steps 3 & 4:
#       3.Uses descriptive activity names to name the activities in the data set
#       4. Appropriately labels the data set with descriptive variable names. 
#---------------------

#rename columns in final dataset
colNames <- colnames(dat.sub)
for (i in 1:length(colNames)) 
{
        colNames[i] <- gsub("^(t)","time",colNames[i])
        colNames[i] <- gsub("^(f)","freq",colNames[i])
        colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] <- gsub("AccMag","AccMagnitude",colNames[i])
        colNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
        colNames[i] <- gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] <- gsub("GyroMag","GyroMagnitude",colNames[i])
        colNames[i] <- gsub("\\.(?=\\.*$)", "", colNames[i], perl=TRUE)
}
colnames(dat.sub) <- colNames

#use descriptive activity names to name the activities in the data set
for(i in 1:nrow(dat.sub)){
        if (dat.sub[i, 3] == "1") {
                dat.sub[i, 3] <- "Walking"
        } else if (dat.sub[i, 3] == "2") {
                dat.sub[i, 3] <- "Walking Upstairs"
        } else if (dat.sub[i, 3] == "3") {
                dat.sub[i, 3] <- "Walking Downstairs"
        } else if (dat.sub[i, 3] == "4") {
                dat.sub[i, 3] <- "Sitting"
        } else if (dat.sub[i, 3] == "5") {
                dat.sub[i, 3] <- "Standing"
        } else if (dat.sub[i, 3] == "6") {
                dat.sub[i, 3] <- "Laying"
        }
}

#---------------------
#    Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject
#---------------------
#get mean of each variable for each subject and activity
dat.final <- aggregate(dat.sub[, 4:89], by = list(Subject.ID = dat.sub$Subj.ID, Activity = dat.sub$Activity), FUN = mean, simplify = TRUE, na.action = na.omit)

#create file for uploading to Coursera website
write.table(dat.final, "tidy_data.txt", row.names = FALSE)
