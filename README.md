ProgrammingAssignment3
======================

Coursera Data Science Month 3 (Getting and Cleaning Data) programming assignment

===========================================================================

### 1. Input files

The following files are required by this R script (```run_analysis.R```):

```
features.txt
myfeaturenames.txt
activity_labels.txt
train/X_train.txt
train/y_train.txt
train/subject_train.txt
test/X_test.txt
test/y_test.txt
test/subject_test.txt
```

For output produced by this R script, see the following section.


### 2. Output file (tidy data set)

The following "tidy data" is a comma-separate value (csv) file that may be read in R using the read.csv() function:

```
average_measurements
```

This file contains the average of each "mean" and "std" variable, grouped into 180 categories.  The categories are defined by each combination of 6 activities and 30 subjects.  (The file ```codebook.md``` describes the variables in much greater detail.)

This format meets the requirements of tidy data:
1. Each variable is in a unique column.
2. Each observation is in a unique row.
3. Each observational unit forms a unique table.
4. The top (first) row includes descriptive names for the variables.


### 3. Executing the R script

Download the input files listed in the above section, available in this github repository.  Then load and run (source) the R script ```run_analysis.R```  The script will write the output file described in the above section.


### 4. Explanation of algorithm

The steps below explain the algorithm.

#### 4.1 Read the feature names

Before reading the data, read and cleanup the feature names.  To improve speed, visually examine the data set beforehand, to define the column classes and to set the comment.char.

#### 4.2 Clean up illegal characters in the feature names

This makes it possible to use the feature names, for example, as a named field in a data frame (e.g., x$feature).

The make.names() function is one way to see what characters are considered illegal: <br>
&nbsp;&nbsp;&nbsp; data.frame(orig=df, new=make.names(df))

#### 4.3 Extract "only the measurements on the mean and standard deviation for measurement"

There is much discussion on the course web site about the ambiguity of this step.  Does this include features derived from the mean, such as "fBodyAcc-meanFreq()-X" or "angle(X,gravityMean)"?  The only guidance is to explain your choice.

Therefore, I chose to err on the side of caution.  I believe that it is better to include additional, unnecessary features than to exclude necessary features.

I extract all feature names including "mean" or "std", ignoring case.

#### 4.4 Read the training and test dat

Previous examination determined that all columns are numeric.  For example, sum(sapply(xtrain,class)=="numeric") == ncol(xtrain)

#### 4.5 Combine together the training and test data

When combining, include only the "mean" and "std" features, as described above.

> xcombined: 10299 rows, 86 columns (53 "mean" + 33 "std")
> ycombined: 10299 rows, 1 column
> scombined: 10299 rows, 1 column

#### 4.6 Assign descriptive column names

For the "mean" and "std" features, I edited a separate file that expands each of the original feature names into a more descriptive feature name.

The 1st column contains the raw names (after removing illegal characters). <br>
The 2nd column contains the descriptive feature names. <br>
(Read this data as characters, rather than (default) factors.)

#### 4.7 Combine the X, Y, and sample data sets

Append the Y data set (numeric labels [1..6] for activity) and the subject_train data set (numeric labels [1..30] for subject id) to the X data set (measurement data) as additional columns.

Replace the column names with more descriptive choices.

#### 4.8 Replace the numeric activity labels with descriptive names

For the activity names, I used the file provided with the data.

The 1st column contains the numeric actiivty labels [1..6]. <br>
The 2nd column contains the descriptive activity names. <br>
(Read this data as characters, rather than (default) factors.)

Map the numeric activity data to the descriptive activity names using sapply() and replace this column in the data frame.

#### 4.9 Create a separate data set containing the average of each measurement variable for each combination of activity and subject.

There are 6 activities and 30 subjects, so there will be 6*30 = 180 groups. <br>
There will be length(myfeaturenames) = 86 averaged measurements, for each of the 180 groups.

Melt the previous data frame, using id variables Activity and Subject. <br>
By default, it uses all remaining unspecified variables as measured.vars. <br>
(Use default 'variable' and 'value' names for the measured variables.)

Use dcast() to aggregate together the measured data in the 'variable' column, grouped by Activity and Subject.  Aggregate the 'variable' data within each group using the mean.

#### 4.10 Write the data frame to an output file in csv (comma-separated value) format

