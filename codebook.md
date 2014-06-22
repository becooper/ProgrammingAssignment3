## Codebook for course project (peer assessment)

Getting and Cleaning Data, Month 3 of Coursera series on Data Science

---------------------------------------------------------------------------

**Table of Contents**

1. *Study design:* Description of collected data <br>
   1.1 Background <br>
   1.2 Selection of variables <br>
2. *Variable description: ("codebook"):* Information about variables included in the tidy dat set. <br>
   2.1 Measurement variables <br>
   &nbsp;&nbsp;&nbsp; 2.1.1 Basis for descriptive variable name choices <br>
   &nbsp;&nbsp;&nbsp; 2.1.2 Units <br>
   2.2 Category variables <br>
   2.3 List of variable names in the tidy data

For a description of the R script and associated data files, please refer to README.md.

---------------------------------------------------------------------------

## 1. Study design

### 1.1 Background

The programming assignment provides the following background for the experiment and its associated data:

> "Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:"

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Below is a link that contains the data for this project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


### 1.2 Selection of variables

The instructions (below) describe generally which measurements should be extracted from the collection of raw data:

> "[Extract] only the measurements on the mean and standard deviation for each measurement."

However, there is ambiguity regarding its exact interpretation, as some measurements are derived from the "meanFreq" or from an angular measurement.  The course forums (cited below) emphasize that the choice is subjective and recommend simply justifying your choice in the associated documentation.

I chose to include all variants of "mean" and "std," including those mentioned above.  I preferred to include potentially unnecessary data rather than to exclude potentially necessary data.  In a real-life situation, I would contact the customer for clarification.

In summary, I chose a total of 86 measurements:

53 features are time-domain measurements. <br>
33 features are frequency-domain measurements. <br>
(7 of the 53 time-domain features describe the angle between a pair of vectors.)

David's Assignment FAQ <br>
https://class.coursera.org/getdata-004/forum/thread?thread_id=106

> * columns are measurements on the mean and standard deviation
> 
> "Based on column names in the features is an open question as to is the the entries that include mean() and std() at the end, or does it include entries with mean in an earlier part of the name as well. There are no specific marking critieria on the number of columns. It is up to you to make a decision and explain what you did to the data. Make it easy for people to give you marks by explaining your reasoning."
> 

Or as Abigal Groff succintly clarified: <br>
https://class.coursera.org/getdata-004/forum/thread?thread_id=106#comment-339

> "The features.txt file contains multiple entries with mean() or std() occurring in different parts of the name. Its up to you to decide which ones to use (ie only -mean()? or also include -meanFreq()?)"

Again, Scott von Kleeck (Community TA) clarifies that you can choose either to include or exclude measurements with "meanFreq" in their names: <br>
https://class.coursera.org/getdata-004/forum/thread?thread_id=219#comment-1213

> "It is your choice if you want to include those variables or exclude them.  Either way, note your decision in your code book so it is clear that you made a choice."


## 2. Description of variables

### 2.1 Measurement variables

#### 2.1.1 Basis for descriptive variable name choices

The choice of suitable descriptive names for the variables is another subjective decision.  The main point stressed in the course discussion forums is to remove illegal or problematic characters (such as a dash, plus, or parenthesis) from the originally provided variables names.  The removal of such characters assures that these variable names can be used safely and easily in the context of R programming.

I chose fully descriptive names without any abbreviations, although this is likely more than what is necessary for most applications.  All variable names have more than one word, so I separated words with a period (".") rather than a space (" "), since the former is a legal character for variable names in R.


#### 2.1.2 Units

As specified in the original data (README.txt), the experiment collected measurements every 0.02 seconds, or at a frequency of 50 Hz.

Time domain measurements: 0.02 seconds per sample <br>
Frequency domain measurements: 50 Hz (50 samples per second)

Additional background is available in the README.txt file of the original data.  For example, the experimenters processed the raw sensor measurements within a 128-sample (2.56-sec) sliding window with 50% overlap.  They removed noise but did not mention any details.

The sensor data measures combined acceleration from both gravity and the subject's body.  However, for practical purposes, gravity should be nearly constant.  Therefore, the experimenters extract gravity from the combined acceleration using a low-pass filter (Butterworth low-pass filter with a 0.3 Hz cutoff frequency).  The difference between the total signal and gravity defines the acceleration of the subject's body.

Note that features are normalized and bounded within the range [-1,1].

### 2.2 Category variables

In addition to the measurement variables described above, the tidy data set includes the variables Activity and Subject.

The Activity has 6 possible values, represented in the raw data set as the numbers 1 through 6.  However, the tidy data set replaced these with the descriptive names below, found in activity_labels.txt.

```
WALKING
WALKING_UPSTAIRS
WALKING_DOWNSTAIRS
SITTING
STANDING
LAYING
```

The Subject has 30 possible values, represented in the raw data set as the numbers 1 through 30.  These labels were preserved, since (1) no additional clarification was provided or requested and (2) personally-identifiable data is neither necessary nor desirable (in terms of privacy) for such experiments.

### 2.3 List of variable names in the tidy data

The tidy data set includes 180 rows (observations) and 88 columns (variables).  (I preferred the "wide" format rather than the much larger "long" format, as visualization is easier.)

There is one row for each combination of 6 activities and 30 subjects.  (Thus, 6*30 = 180.)

Each observation includes the average of the 86 variables within that particular group, defined for a particular activity and subject.

 2 features (Activity and Subject) were added by the R script <br>
53 features are time-domain measurements. <br>
33 features are frequency-domain measurements. <br>

```
Activity
Subject
Body.acceleration.mean.X.direction
Body.acceleration.mean.Y.direction
Body.acceleration.mean.Z.direction
Gravity.acceleration.mean.X.direction
Gravity.acceleration.mean.Y.direction
Gravity.acceleration.mean.Z.direction
Body.acceleration.jerk.mean.X.direction
Body.acceleration.jerk.mean.Y.direction
Body.acceleration.jerk.mean.Z.direction
Body.gyroscopic.mean.X.direction
Body.gyroscopic.mean.Y.direction
Body.gyroscopic.mean.Z.direction
Body.gyroscopic.jerk.mean.X.direction
Body.gyroscopic.jerk.mean.Y.direction
Body.gyroscopic.jerk.mean.Z.direction
Body.acceleration.magnitude.mean
Gravity.acceleration.magnitude.mean
Body.acceleration.jerk.magnitude.mean
Body.gyroscopic.magnitude.mean
Body.gyroscopic.jerk.magnitude.mean
Body.frequency.acceleration.mean.X.direction
Body.frequency.acceleration.mean.Y.direction
Body.frequency.acceleration.mean.Z.direction
Mean.frequency.of.body.acceleration.X.direction
Mean.frequency.of.body.acceleration.Y.direction
Mean.frequency.of.body.acceleration.Z.direction
Body.frequency.acceleration.jerk.mean.X.direction
Body.frequency.acceleration.jerk.mean.Y.direction
Body.frequency.acceleration.jerk.mean.Z.direction
Mean.frequency.of.body.acceleration.jerk.X.direction
Mean.frequency.of.body.acceleration.jerk.Y.direction
Mean.frequency.of.body.acceleration.jerk.Z.direction
Body.frequency.gyroscopic.mean.X.direction
Body.frequency.gyroscopic.mean.Y.direction
Body.frequency.gyroscopic.mean.Z.direction
Mean.frequency.of.body.gyroscopic.X.direction
Mean.frequency.of.body.gyroscopic.Y.direction
Mean.frequency.of.body.gyroscopic.Z.direction
Body.frequency.acceleration.magnitude.mean
Mean.frequency.of.body.acceleration.magntiude
Body.frequency.acceleration.jerk.magnitude.mean
Mean.frequency.of.body.acceleration.jerk
Body.frequency.gyroscopic.magnitude.mean
Mean.frequency.of.body.gyroscopic.magnitude
Body.frequency.gyroscopic.jerk.magnitude.mean
Mean.frequency.of.body.jerk.magnitude
Angle.between.body.acceleration.mean.and.gravity
Angle.between.mean.body.acceleration.jerk.and.mean.gravity
Angle.between.mean.body.gyroscopic.and.mean.gravity
Angle.between.mean.body.gyroscopic.jerk.and.mean.gravity
Angle.between.X.direction.and.mean.gravity
Angle.between.Y.direction.and.mean.gravity
Angle.between.Z.direction.and.mean.gravity
Body.acceleration.standard.deviation.X.direction
Body.acceleration.standard.deviation.Y.direction
Body.acceleration.standard.deviation.Z.direction
Gravity.acceleration.standard.deviation.X.direction
Gravity.acceleration.standard.deviation.Y.direction
Gravity.acceleration.standard.deviation.Z.direction
Body.acceleration.jerk.standard.deviation.X.direction
Body.acceleration.jerk.standard.deviation.Y.direction
Body.acceleration.jerk.standard.deviation.Z.direction
Body.gyroscopic.standard.deviation.X.direction
Body.gyroscopic.standard.deviation.Y.direction
Body.gyroscopic.standard.deviation.Z.direction
Body.gyroscopic.jerk.standard.deviation.X.direction
Body.gyroscopic.jerk.standard.deviation.Y.direction
Body.gyroscopic.jerk.standard.deviation.Z.direction
Body.acceleration.magnitude.standard.deviation
Gravity.acceleration.magnitude.standard.deviation
Body.acceleration.jerk.magnitude.standard.deviation
Body.gyroscopic.magnitude.standard.deviation
Body.gyroscopic.jerk.magnitude.standard.deviation
Body.frequency.acceleration.standard.deviation.X.direction
Body.frequency.acceleration.standard.deviation.Y.direction
Body.frequency.acceleration.standard.deviation.Z.direction
Body.frequency.acceleration.jerk.standard.deviation.X.direction
Body.frequency.acceleration.jerk.standard.deviation.Y.direction
Body.frequency.acceleration.jerk.standard.deviation.Z.direction
Body.frequency.gyroscopic.standard.deviation.X.direction
Body.frequency.gyroscopic.standard.deviation.Y.direction
Body.frequency.gyroscopic.standard.deviation.Z.direction
Body.frequency.acceleration.magnitude.standard.deviation
Body.frequency.acceleration.jerk.magnitude.standard.deviation
Body.frequency.gyroscopic.magnitude.standard.deviation
Body.frequency.gyroscopic.jerk.magnitude.standard.deviation
```
