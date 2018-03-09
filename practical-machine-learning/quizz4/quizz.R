library(ElemStatLearn)
library(dplyr)
library(AppliedPredictiveModeling)
library(caret)
library(ElemStatLearn)
library(pgmm)
library(rpart)
library(gbm)
library(lubridate)
library(forecast)
library(e1071)
library(elasticnet)
library(lubridate)
library(e1071)


# Q1
data(vowel.train)
data(vowel.test)

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)

rf <- train(y ~ ., data = vowel.train, method = "rf")
gbm <- train(y ~ ., data = vowel.train, method = "gbm")

y_rf <- predict(rf, vowel.test)
y_gbm <- predict(gbm, vowel.test)
caret::confusionMatrix(y_rf, vowel.test$y) # accuracy=0.5779
caret::confusionMatrix(y_gbm, vowel.test$y) # accuracy=0.526
agreement <- which(y_rf == y_gbm)
caret::confusionMatrix(y_rf[agreement], vowel.test$y[agreement]) # accuracy=0.6288


# Q2

set.seed(3433)

data(AlzheimerDisease)

adData = data.frame(diagnosis,predictors)

inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]

training = adData[ inTrain,]

testing = adData[-inTrain,]

set.seed(62433)

rf <- train(diagnosis ~ ., data = training, method = "rf")
gbm <- train(diagnosis ~ ., data = training, method = "gbm")
lda <- train(diagnosis ~ ., data = training, method = "lda")
stacked.data <- data.frame(rf = predict(rf, training), gbm = predict(gbm, training), lda = predict(lda, training), diagnosis = training$diagnosis)
stacked.model <- train(diagnosis ~ ., data = stacked.data, method = "rf")

y.rf <- predict(rf, testing)
y.gbm <- predict(gbm, testing)
y.lda <- predict(lda, testing)
stacked.test <- data.frame(rf = y.rf, gbm = y.gbm, lda = y.lda)
y.stacked <- predict(stacked.model, stacked.test)
caret::confusionMatrix(y.rf, testing$diagnosis)$overall[1]
caret::confusionMatrix(y.gbm, testing$diagnosis)$overall[1]
caret::confusionMatrix(y.lda, testing$diagnosis)$overall[1]
caret::confusionMatrix(y.stacked, testing$diagnosis)$overall[1]


# Q3

set.seed(3523)

data(concrete)

inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]

training = concrete[ inTrain,]

testing = concrete[-inTrain,]

set.seed(233)

lasso.model <- train(CompressiveStrength ~ ., training, method = "lasso")
plot.enet(lasso.model$finalModel)


# Q4

dat = read.csv("~/Documents/perso/Perso/Coursera/Data Science - John Hopkins/datasciencecoursera/practical-machine-learning/quizz4/gaData.csv")

training = dat[year(dat$date) < 2012,]

testing = dat[(year(dat$date)) > 2011,]

tstrain = ts(training$visitsTumblr)

bats.model <- bats(tstrain)
y.hat <- forecast(bats.model, h=nrow(testing))
upper <- y.hat$upper[,2]
lower <- y.hat$lower[,2]
sum((testing$visitsTumblr > lower) & (testing$visitsTumblr < upper)) / nrow(testing)


# Q5

set.seed(3523)

data(concrete)

inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]

training = concrete[ inTrain,]

testing = concrete[- inTrain,]
testing.data <- testing %>%
  select(-CompressiveStrength)
y.test <- testing$CompressiveStrength

set.seed(325)

svr <- e1071::svm(CompressiveStrength ~ ., training)
y.hat <- predict(svr, testing)

sqrt(mean((y.test - y.hat)^2))
