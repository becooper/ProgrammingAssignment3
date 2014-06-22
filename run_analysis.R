#==========================================================================
#
# Getting and Cleaning Data
# Month 3 of Coursera series on Data Science
#
# Course project (peer assessment)

#--------------------------------------------------------------------------
#
# The following files are required by this R script:
#
# features.txt
# myfeaturenames.txt
# activity_labels.txt
# train/X_train.txt
# train/y_train.txt
# train/subject_train.txt
# test/X_test.txt
# test/y_test.txt
# test/subject_test.txt
#
# The output data frame will be written to the following file:
#
# average_measurements.csv
#
# This file contains the average of each "mean" and "std" variable, grouped
# into 180 categories.  The categories are defined by each combination of 6
# activities and 30 subjects.
#
#==========================================================================

#--------------------------------------------------------------------------
#
# 1. Read the feature names.
#
#--------------------------------------------------------------------------

# Before reading the data, read and cleanup the feature names.
# To improve speed, visually examine the data set beforehand,
# to define the column classes and to set the comment.char.

df <- read.table("features.txt", colClasses=c("numeric","character"), comment.char="")
allfeaturenames <- df[,2]
rm(df)

#--------------------------------------------------------------------------
#
# 2. Clean up illegal characters in the feature names.
#
# This makes it possible to use the feature names, for example,
# as a named field in a data frame (e.g., x$feature).
#
# The make.names() function is one way to see what characters
# are considered illegal:
#
#   data.frame(orig=df, new=make.names(df))
#
#--------------------------------------------------------------------------

allfeaturenames <- gsub("\\-|\\,", "_", allfeaturenames)  # Replace dash with underscores
allfeaturenames <- gsub("\\(|\\)", "", allfeaturenames)   # Remove parentheses

#--------------------------------------------------------------------------
#
# 3. Extract "only the measurements on the mean and standard deviation for
#    each measurement."
#
# There is much discussion on the course web site about the ambiguity of this
# step.  Does this include features derived from the mean, such as
# "fBodyAcc-meanFreq()-X" or "angle(X,gravityMean)"?  The only guidance is to
# explain your choice.
#
# Therefore, I chose to err on the side of caution.  I believe that it is
# better to include additional, unnecessary features than to exclude necessary
# features.
#
# I extract all feature names including "mean" or "std", ignoring case.
#
#--------------------------------------------------------------------------

# mfeaturenames.idx <- grep("mean", allfeaturenames)  # lowercase only: 46 features
# sfeaturenames.idx <- grep("std", allfeaturenames)   # lowercase only: 33 features
mfeaturenames.idx <- grep("mean", allfeaturenames, ignore.case=TRUE)  # 53 features
sfeaturenames.idx <- grep("std", allfeaturenames, ignore.case=TRUE)   # 33 features
featurenames.idx <- unique(c(mfeaturenames.idx,sfeaturenames.idx))

# writeLines(allfeaturenames[featurenames],"rawfeaturenames.txt")

#--------------------------------------------------------------------------
#
# 4. Read the training and test data
#
# Previous examination determined that all columns are numeric.
# For example, sum(sapply(xtrain,class)=="numeric") == ncol(xtrain)
#
#--------------------------------------------------------------------------

dirtrain <- "train"
xtrain <- read.table(paste(dirtrain,"X_train.txt",sep="/"), colClasses="numeric")
ytrain <- read.table(paste(dirtrain,"y_train.txt",sep="/"), colClasses="numeric")
strain <- read.table(paste(dirtrain,"subject_train.txt",sep="/"), colClasses="numeric")

dirtest <- "test"
xtest <- read.table(paste(dirtest,"X_test.txt",sep="/"), colClasses="numeric")
ytest <- read.table(paste(dirtest,"y_test.txt",sep="/"), colClasses="numeric")
stest <- read.table(paste(dirtest,"subject_test.txt",sep="/"), colClasses="numeric")

#--------------------------------------------------------------------------
#
# 5. Combine together the training and test data
#
# When combining, include only the "mean" and "std" features, as described
# above.
#
# xcombined: 10299 rows, 86 columns (53 "mean" + 33 "std")
# ycombined: 10299 rows, 1 column
# scombined: 10299 rows, 1 column
#
#--------------------------------------------------------------------------

xcombined <- rbind(xtrain[,featurenames.idx], xtest[,featurenames.idx])
ycombined <- rbind(ytrain, ytest)
scombined <- rbind(strain, stest)

#--------------------------------------------------------------------------
#
# 6. Assign descriptive column names
#
# For the "mean" and "std" features, I edited a separate file that expands
# each of the original feature names into a more descriptive feature name.
#
# The 1st column contains the raw names (after removing illegal characters).
# The 2nd column contains the descriptive feature names.
# (Read this data as characters, rather than (default) factors.)
#
#--------------------------------------------------------------------------

myfeaturenames <- read.table("myfeaturenames.txt",
                             stringsAsFactors=FALSE)[,2]   # keep only 2nd col

# If the external file somehow has a different number of feature names than
# the actual data, then skip the external file and use the less-descriptive
# names of the actual data.

if ( length(myfeaturenames) != length(featurenames.idx) ) {
    printf("Descriptive feature name file has %d entries, ",
           length(myfeaturenames));
    printf("but there are %d raw features.\n", length(featurenames.idx));
    printf("We will ignore descriptive feature names for now, ");
    printf("but you should edit this file and re-run.\n");
    myfeaturenames <- allfeaturenames[featurenames.idx];
}

#--------------------------------------------------------------------------
#
# 7. Combine the X, Y, and sample data sets.
#
# Append the Y data set (numeric labels [1..6] for activity) and the
# subject_train data set (numeric labels [1..30] for subject id)
# to the X data set (measurement data) as additional columns.
#
# Replace the column names with more descriptive choices.
#
#--------------------------------------------------------------------------

df <- cbind( xcombined, ycombined, scombined )
colnames(df) <- c(myfeaturenames, "Activity", "Subject")

#--------------------------------------------------------------------------
#
# 8. Replace the numeric activity labels with descriptive names.
#
# For the activity names, I used the file provided with the data.
#
# The 1st column contains the numeric actiivty labels [1..6].
# The 2nd column contains the descriptive activity names.
# (Read this data as characters, rather than (default) factors.)
#
# Map the numeric activity data to the descriptive activity names
# using sapply() and replace this column in the data frame.
#
#--------------------------------------------------------------------------

activitynames <- read.table("activity_labels.txt",
                            stringsAsFactors=FALSE)[,2]   # keep only 2nd col

df$Activity <- sapply(df$Activity, function(x) activitynames[x])

#--------------------------------------------------------------------------
#
# 9. Create a separate data set containing the average of each measurement
#    variable for each combination of activity and subject.
#
# There are 6 activities and 30 subjects, so there will be 6*30 = 180 groups.
# There will be length(myfeaturenames) = 86 averaged measurements,
# for each of the 180 groups.
#
# Melt the previous data frame, using id variables Activity and Subject.
# By default, it uses all remaining unspecified variables as measured.vars.
# (Use default 'variable' and 'value' names for the measured variables.)
#
# Use dcast() to aggregate together the measured data in the 'variable'
# column, grouped by Activity and Subject.  Aggregate the 'variable' data
# within each group using the mean.
#
#--------------------------------------------------------------------------

library(reshape2)  # melt() and dcast()

m <- melt(df,id.vars=c("Activity","Subject"))
d <- dcast(m, Activity + Subject ~ variable,mean)

write.csv(d,"average_measurements.csv")

# Instead of using melt() and dcast(), you can use tapply() to perform
# conventional subsetting.  However, it can perform the aggregation on only
# one variable at a time:
#
#   x1<-tapply(df[,1],list(df$Activity,df$Subject),mean)
#   x2<-tapply(df[,2],list(df$Activity,df$Subject),mean)
#   x3<-tapply(df[,3],list(df$Activity,df$Subject),mean)
#   ...
#
# So you could use a loop across each of the variables,
# and then rbind() them together into a data frame.
