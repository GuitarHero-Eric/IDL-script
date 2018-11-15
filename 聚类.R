library(tidyverse)
library(summarytools)
flights<-read.csv("NYCflights3.csv")
# flights1 <- read_csv("https://gitlab.com/wshuyi/demo-data-flights/raw/master/flights.csv")
# view(dfSummary(flights1))
view(dfSummary(flights))

a<-rnorm(100,50,2) %>%
 "*"(50)%>%
  abs%>%
  data.frame()

test<-read.csv("kmeans test.csv")
k<-test%$%.[is.na(test$标号)==FALSE,]
k<-k[,3:5]
kmeans<-kmeans(k,2)




library(fpc)

data(iris)

df<-iris[,c(1:4)]

set.seed(252964) # 设置随机值，为了得到一致结果。

(kmeans <- kmeans(na.omit(df), 3)) # 显示K-均值聚类结果

plotcluster(na.omit(df), kmeans$cluster) # 生成聚类图

iris2 <- iris
iris2$Species <- NULL
kmeans.result <- kmeans(iris2, 3)
plot(iris2[c("Sepal.Length", "Sepal.Width")], col = kmeans.result$cluster)
points(kmeans.result$centers[,c("Sepal.Length", "Sepal.Width")], col = 1:3, pch = 8, cex=2)
