# 加载工具包
# xlsx处理
library("xlsx")
library("rJava")
# 数据整形split – apply – combine
library(plyr)
# 数据清洗
library(tidyverse)
# 数据概览
library(summarytools)
# 爬虫“Hadley Wickham 开发的“rvest”
library('rvest')
# 数据管道操作包
library("magrittr")
library("corrplot")
# 统计分析报
library(car) 
# 数据挖掘gui工具
library("rattle")
# Classification and Regression Training
library(caret)
# 分词
library(jiebaR)
# 词云
library(wordcloud)
library(wordcloud2)

# 加载自编函数
setwd("D:\\R路径\\pac")
source("transX.R")
source("transW-V1.R")
source("transN新.R")
source("transD-V1.R")
setwd("D:\\R路径\\基础数据")
# XYD
# a<-loadN(date = "20180627")
# 现金贷
# b<-loadX(date = "20180627")
# 五级分类
# c<-loadW(date="2018-06-27")
# 逾期客户表

