# Taken from: https://github.com/dmlc/xgboost/blob/master/R-package/vignettes/xgboostPresentation.Rmd

require(xgboost)
data(agaricus.train, package='xgboost')
data(agaricus.test, package='xgboost')
train <- agaricus.train
test <- agaricus.test
str(train)
dim(train$data)
dim(test$data)
class(train$data)[1]
class(train$label)

bstSparse <- xgboost(data = train$data, label = train$label, max_depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic")
bstDense <- xgboost(data = as.matrix(train$data), label = train$label, max_depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic")
dtrain <- xgb.DMatrix(data = train$data, label = train$label)
bstDMatrix <- xgboost(data = dtrain, max_depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic")
bst <- xgboost(data = dtrain, max_depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic", verbose = 2)
pred <- predict(bst, test$data)
print(length(pred))
print(head(pred))
prediction <- as.numeric(pred > 0.5)
print(head(prediction))
err <- mean(as.numeric(pred > 0.5) != test$label)
print(paste("test-error=", err))
dtrain <- xgb.DMatrix(data = train$data, label=train$label)
dtest <- xgb.DMatrix(data = test$data, label=test$label)
watchlist <- list(train=dtrain, test=dtest)
bst <- xgb.train(data=dtrain, max_depth=2, eta=1, nthread = 2, nrounds=2, watchlist=watchlist, objective = "binary:logistic")
bst <- xgb.train(data=dtrain, max_depth=2, eta=1, nthread = 2, nrounds=2, watchlist=watchlist, eval_metric = "error", eval_metric = "logloss", objective = "binary:logistic")
