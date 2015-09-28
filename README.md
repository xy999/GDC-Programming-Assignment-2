# GDC-Programming-Assignment-2
---
**README file description**  
  
The code in this project performs the following functions:  
 1. Merges the training and the test sets to create one data set.  
 2. Extracts only the measurements on the mean and standard deviation for each measurement.   
 3. Uses descriptive activity names to name the activities in the data set  
 4. Appropriately labels the data set with descriptive variable names.   
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
  
Detailed descriptions of each step are provided below:  
  
**Step 1: Merges the training and the test sets to create one data set**    
  
*Training Data*  
* Load training data and label columns: generates a vector of features from features.txt and applies them as column names when reading in X_train.txt  
* Read in Individual ID and Activity lists and merge them using cbind  
* Create data frame to use for marking the training data as the Training Group  
* Bind all elements created thus far to create the training data object  
  
*Test Data*  
* Repeats the steps from Training Data above to create the test data object  
  
*Master Dataset*  
* Merge training and test datasets using rbind to create a master dataset  
  
**Step 2: Extracts only the measurements on the mean and standard deviation for each measurement**  
* Using the "master dataset" above, uses grep to find the number of the columns where "mean" and "std" appear, and then subsets only those and then cbind them  
  
**Steps 3 & 4: (3)Uses descriptive activity names to name the activities in the data set; and (4) Appropriately labels the data set with descriptive variable names**  
* Rename columns in final dataset using gsub and a "for" loop to clean them  
* Use a "for" loop to match descriptive activity names to numbers indicating different activities  
  
**Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject**  
* Use aggregate on cols 4-89 to calculate the mean of each variable for each subject and activity  
* Create a file for uploading to Coursera website  
