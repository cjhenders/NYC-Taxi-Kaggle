# Made for Kaggle NYC Taxi Ride Estimates competition.

library(readr)
library(tibble)
library(lubridate)
library(dplyr)
library(caret)

#Import data set to be processed
train <- read_csv("~/Documents/Kaggle Club/NYC Taxi/train 2.csv")
#test_set <- read_csv("~/Documents/Kaggle Club/NYC Taxi/test 2.csv")
#test_set$dropoff_datetime = NA
#test_set$trip_duration = NA
#train = combine(train_set,test_set)

#Data Manipulation for easier training
train$vendor_id = as.factor(train$vendor_id)
train$passenger_count = as.factor(train$passenger_count)
train$pickup_datetime = ymd_hms(train$pickup_datetime)
train$dropoff_datetime = ymd_hms(train$dropoff_datetime)


#Feature Creation

#Creating Trip distance from Long and Lat
pick_coord = train %>%
  select(pickup_longitude, pickup_latitude)
drop_coord = train %>%
  select(dropoff_longitude, dropoff_latitude)
train$dist = distCosine(pick_coord,drop_coord)

train$date = date(train$pickup_datetime)
train$month = month(train$pickup_datetime, label = TRUE)
train$wday = wday(train$pickup_datetime, label = TRUE)
train$hour = hour(train$pickup_datetime)

#Remove unnecessary predictors
train$dropoff_datetime = NULL
train$store_and_fwd_flag = NULL
train$id = NULL

#Training Support Vector Machine
svm_model = train(train$trip_duration ~., data = train, method = "svmRadial")

