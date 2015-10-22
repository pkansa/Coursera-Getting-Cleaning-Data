# Introduction

The script `run_analysis.R`performs the 5 steps described in the course project's definition.

* Merge the training and the test sets to create one data set.
* Extract only the measurements on the mean and standard deviation for each measurement. 
* Apply descriptive activity names from the provided files to name the activities in the data set
* Correct the column names (labels) on the dataet to get things to be more descriptive and human-readable
* The final step is to generate a secondary (tidy) dataset for each subject/activity, which is then output to 'tidydata.txt'

# Variables

* `subject_train, `x_train`, `y_train`, `subject_test`, `x_test`, and `y_test` contain the data from the downloaded and unzipped files.
* `x_data`, `y_data` and `subject_data` then combines those initial dataset so further cleanup can be done before the final merging
* `activity_labels` is used to accurately labelt the activities that were being measured (applied to the `y_data` dataset)
* `features` contains the supplied names for the `x_data` dataset
* `FeaturesNeeded` is a filtered vector of those measures we actually want in hte final dataset
* `x_data_sub` then uses the `FeaturesNeeded` to pull out the subset of data we actually need
* `combined_data` merges `x_data_sub`, `y_data` and `subject_data` in a big dataset.
* `tidydata` is the final dataset with the averages of the requested measures which are then output to a text file