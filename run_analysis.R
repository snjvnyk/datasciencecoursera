## give the path to the UCI HAR Dataset
path = '/home/abhishekdubey/Downloads/UCI HAR Dataset'

## import the imformation necesaary for the dataset
act_labels <- fread(file.path(path, 'activity_labels.txt'), col.names = c('Labels', 'activity_name'))
all_features <- fread(file.path(path, 'features.txt'), col.names = c('index','featuresName'))
features_wanted_index <- grep("(mean|std)\\(\\)", all_features[, featuresName])
measurements <- all_features[features_wanted_index, featuresName]
measurements <- gsub("[()]","", measurements)

#get the training data
X_train <- fread(file.path(path, 'train/X_train.txt'))[, features_wanted_index, with = FALSE]
colnames(X_train) <- measurements
Y_train <- fread(file.path(path, 'train/y_train.txt'), col.names = 'Activity')
subject_train <- fread(file.path(path, 'train/subject_train.txt'), col.names =  'subjectnum')
X_train <- cbind(X_train, Y_train, subject_train)

#get the test data
X_test <- fread(file.path(path, 'test/X_test.txt'))[, features_wanted_index, with = FALSE]
colnames(X_test) <- measurements
Y_test <- fread(file.path(path, 'test/y_test.txt'), col.names = 'Activity')
subject_test <- fread(file.path(path, 'test/subject_test.txt'), col.names = 'subjectnum')
X_test <- cbind(X_test, Y_test, subject_test)

#combining the dataset
X <- rbind(X_train, X_test)

X[['Activity']] <- factor(X[, Activity], levels = act_labels[['Labels']], labels = act_labels[['activity_name']])
X[['subjectnum']] <- as.factor(X[, subjectnum]) ##tidy dataset  

X_sep <- reshape2::melt(X, id = c('subjectnum', 'Activity'))
X_sep <- reshape2::dcast(X_sep, subjectnum + Activity ~ variable, fun.aggregate = mean) ##getting the mean of the required measurements


write.table(x = X_sep, file= 'tidydata.txt', row.names = FALSE)

