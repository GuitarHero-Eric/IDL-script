#install.packages("CORElearn")
#library(installr)
#updateR()

rm(list=ls())
getwd()
setwd("C:/Users/idl-user37/desktop")
# 资方数据库
library(RODBC)
con2<-odbcConnect("plcsda",uid="plcsda",pwd="password",believeNRows=FALSE) ##建立Oracle连接
data2<-sqlQuery(con2,"select * from plcs.t_plcs_jbh_loan_reply")
# 我方数据库
library(RODBC)  ##加载RODBC包，没有成功的请先下载安装install.packages("RODBC")
con1<-odbcConnect("shengchan",uid="bpmda",pwd="password",believeNRows=FALSE) ##建立Oracle连接
data1<-sqlQuery(con1,"select application_number, mcht_name from bpmap.LOAN_APPLICATION")
sqlQuery(con1,"delete from 放款结果")

a <-length(data1[1,])
b <-length(data1[,1])
c <-length(data2$PLATFORM_PROJECT_ID)
data3 <- data.frame(data2,0)
#colnames(data3)[13]<-"营销中心"
colnames(data2)[2]<-"APPLICATION_NUMBER"
colnames(data2)[10]<- "ENDTIME"
#print(data1[1,2] )
#data3[1,13] <- as.character(data1[1,2])

#library(readxl)
#data2<- read_xlsx("C:\\Users\\idl-user37\\Desktop\\aaa.xlsx")


#for (m in 1:c) {
#  for(n in 1:b) {
#    if (data2[[m,2]] == data1[[n,1]]){
#    data3[m,13] <- as.character(data1[n,2])
#    }  
#  }
#}      
#install.packages('xlsx')
#library(rJava)
#library(xlsx)
# 合并我方与资方数据库
data4 <- merge.data.frame(data1,data2,by="APPLICATION_NUMBER")
# 提取有用字段
data5 <- data4[,c(1:2,6,11)]
#write.csv2(data4, 'bbb.csv')


sqlSave(con1,data5,tablename='放款结果',append = TRUE)
rm(data4)
 
odbcClose(con1) 
odbcClose(con2)


