library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

set.seed(125)
training <- segmentationOriginal[segmentationOriginal$Case == "Train", ]
testing <- segmentationOriginal[segmentationOriginal$Case == "Test", ]

x_train <- subset(training, select=-c(Class))
p <- ncol(x_train)
var_names <- colnames(x_train)
y_train <- subset(training, select=c(Class))$Class
model <- train(x = x_train, y = y_train, method = "rpart")

model$finalModel


#library(pgmm)
#data(olive)
load("~/Downloads/olive")
olive = olive[,-1]

model = train(x = subset(olive, select=-c(Area)), y = olive$Area, method = "rpart")
newdata = as.data.frame(t(colMeans(olive[,-1])))
predict(model, newdata)


library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]
set.seed(13234)

x_train = subset(trainSA, select = c(age, alcohol, obesity, tobacco, typea, ldl))
y_train = trainSA$chd
model = train(x_train, y_train, method = "glm", family = "binomial")

missClass = function(values,prediction) {
  sum(((prediction > 0.5)*1) != values)/length(values)
}

missClass(trainSA$chd, predict(model, trainSA))
missClass(testSA$chd, predict(model, testSA))


library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
vowel.train$y = as.factor(vowel.train$y)
vowel.test$y = as.factor(vowel.test$y)
set.seed(33833)
library(randomForest)
rf = randomForest(subset(vowel.train, select = -c(y)), vowel.train$y)
varimportance = varImp(rf)
varimportance$variable = row.names(varimportance)
library(dplyr)
varimportance %>%
  arrange(desc(Overall))
