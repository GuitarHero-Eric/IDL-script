# 案例一

set.seed(1)
# watermelon分类 采用watermelon3.0数据集
watermelon_3.0 <- read.csv("watermelon.csv", header = TRUE,row.names = "编号") 
# watermelon$密度 <-as.factor(watermelon$密度)
# watermelon$含糖率 <-as.factor(watermelon$含糖率)
require(caret)
require(magrittr) # %>%
# 哑变量替换(神经网络需要读取数值型信息)
dummies <- dummyVars(" ~.", data = watermelon_3.0, levelsOnly = TRUE,fullRank = TRUE)
watermelon <- predict(dummies, newdata = watermelon_3.0) %>% data.frame()
# 加载神经网络包
require(neuralnet)
predictors <- setdiff(names(watermelon), "好瓜")

formula <- names(watermelon) %>% setdiff("是")  %>% paste(collapse = "+")
formula <- paste("是 ~", formula, sep = "") %>% as.formula()
nn <- neuralnet(formula = formula, data = watermelon, hidden = c(5,3), err.fct = "ce",  linear.output = FALSE)
plot(nn)

library(neuralnet)
require(dplyr)
pred <- neuralnet::compute(nn, dplyr::select(watermelon, -是))
# pred1<-compute(nn, select(watermelon,-是))
result <- pred$net.result
print(result)
predicted <- ifelse(result > 0.5, "是", "否")
table(watermelon_3.0$好瓜, predicted, dnn = c("真实值", "预测值"))


# 案例二
# iris分类 采用自带的iris数据集
# （1）导入数据集iris，并将数据集分割成训练集和测试集两部分
data("iris")
ind<-sample(2,nrow(iris),replace = T,prob = c(0.7,0.3))
trainset<-iris[ind==1,]
testset<-iris[ind==2,]
library(neuralnet)
trainset$setosa<-trainset$Species=="setosa"
trainset$virginica<-trainset$Species=="virginica"
trainset$versicolor<-trainset$Species=="versicolor"
network<-neuralnet(versicolor+virginica+setosa~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width,trainset,hidden = 3)
plot(network)

net.predict<-neuralnet::compute(network,testset[-5])$net.result
net.prediction<-c("versicolor","virginica","setosa")[apply(net.predict,1,which.max)]
predict.table<-table(testset$Species,net.prediction)



dmy<-dummyVars("~.",data=iris)
trsf<-data.frame(predict(dmy,newdata = iris))

