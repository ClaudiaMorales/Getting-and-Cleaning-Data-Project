## Code Book for Getting and Cleaning Data Project

### Overview

[Source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) of the original data:

	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

[Full Description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) where the data was obtained:

	http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
	
### Process as follows:

The script `run_analysis.R` performs the following process to clean up the data
and create dataset:

1. In order to merge the training and test sets to create one data set, I first read the Train data files (subject, activity, features)
   and follow the same process for the Test data files
   a. Uses str() function to examine the properties of the variables from above files
   b. Uses rbind() by pairing the 6 files into Subject, Activity, and Features

2. Reads `features.txt` and uses only the measurements on the mean and standard
   deviation for each measurement 
   a. Uses cbind() to merge all into "Data" with Features, Activity, and Subject variables

3. Reads `activity_labels.txt` and renamed activity names 
   a. Factor the 'activity' variable

4. Labels the data set with descriptive names
   a. Names are converted to lower case; underscores and brackets are removed

5. Created a 'tidyData' set with the average of each variable and subject
   a. Entries are ordered by subject and activity
   b. The result is saved as `tidy.txt`

### Variables

- testData - table contents of `test/X_test.txt`
- trainData - table contents of `train/X_train.txt`
- X - Measurement data. Combined data set of the two above variables
- testSub - table contents of `test/subject_test.txt`
- trainSub - table contents of `test/subject_train.txt`
- S - Subjects. Combined data set of the two above variables
- testLabel - table contents of `test/y_test.txt`
- trainLabel - table contents of `train/y_train.txt`
- Y - Data Labels. Combined data set of the two above variables. 
- featuresList - table contents of `features.txt`
- features - Names of for data columns derived from featuresList
- keepColumns - logical vector of which features to use in tidy data set
- activities - table contents of `activity_labels.txt`. Human readable
- tidyData - subsetted, human-readable data ready for output according to
  project description.
- uS - unique subjects from S
- nS - number of unique subjects
- nA - number of activities
- nC - number of columns in tidyData
- td - second tiny data set with average of each variable for each activity and
  subject

### Output

#### ExtractedData

`ExtractedData.txt` is a 10299x88 data frame.

- The first 86 columns are measurements columns
- The last 2 columns contains activity names and subject IDs, which are integers 1:30

#### tidyData

`tidyData.txt` is a 180x88 data frame.

- The first column contains subject IDs.
- The second column contains activity names.
- The averages for each of the 86 attributes are in columns 3-88.
