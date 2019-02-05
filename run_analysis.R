library(dplyr)
#train data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


#test data 

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Merging data
X_merged <- rbind(X_train, X_test)
Y_merged <- rbind(Y_train, Y_test)
sub_merged <- rbind(sub_train, sub_test)

#selecting features
extracted <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X_merged <- X_merged[,extracted[,1]]

#labels
colnames(Y_merged) <- "activity"
Y_merged$activitylabel <- factor(Y_merged$activity, labels = as.character(activity_labels[,2]))
activity <- Y_merged[,-1]
colnames(X_merged) <- features[extracted[,1],2]
colnames(sub_merged) <- "subject"
#tidy data set
tidy <- cbind(X_merged, activity, sub_merged)
group <- group_by(tidy,activity, subject)
final <- summarize_all(group,funs(mean))
write.table(final, file = "./tidy_data.txt", row.names = FALSE, col.names = TRUE)