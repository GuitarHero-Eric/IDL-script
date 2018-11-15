setwd("D:\\R路径\\基础数据")
library("RODBC")
library("xlsx")
con<-odbcConnect("shengchan",uid="BPMda",pwd="password",believeNRows=FALSE)
a<-sqlQuery(con,"select * from 贷前进件总表")
# 面签耗时
dif<-NULL
for (i in 1:length(a$进件编号)) {
  面签耗时<-difftime(a$面签结束时间[i],a$面签开始时间[i],units="hour")
  dif<-rbind(dif,面签耗时)
}
tt<-cbind(a,dif)
# 读取节假日表
b<-read.csv("节假日表.csv",stringsAsFactors = F)
# 面签横跨休息日天数
kl2<-NULL
for (p1 in 1:length(tt$面签开始时间))
{kl<-length((tt$面签开始时间[p1]>b$休息日)[(tt$面签开始时间[p1]>b$休息日)==T])
kl2<-rbind(kl2,kl)}
# 放款审批结束时间横跨休息日天数
km2<-NULL
for (p2 in 1:length(tt$面签结束时间))
{km<-length((tt$面签结束时间[p2]>b$休息日)[(tt$面签结束时间[p2]>b$休息日)==T])
km2<-rbind(km2,km)}
# 耗时横跨休息日时间  单位天
kn2<-km2-kl2
# 面签开始时间是否为休息日，1为是，0为否
addi<-as.Date(tt$面签开始时间) %in% as.Date(b$休息日)
addi[addi==F]<-0
addi[addi==T]<-1
##kn3面签实际操作天数
kn3<-((as.Date(tt$面签结束时间)-as.Date(tt$面签开始时间))-(kn2+addi))+1
# kn4为包含非工作时间全流程耗时
kn4<-(difftime(tt$面签结束时间,tt$面签开始时间,units="hour")-(kn2*24))
面签实际耗时<-kn4
tt<-cbind(a,面签实际耗时)

# 各面签操作耗时平均值
tt1<-tt[!is.na(tt$面签操作人),]
c<-data.frame(unique(tt1$面签操作人))
all<-NULL
for (i in 1:length(c$unique.tt1.面签操作人.)) {
  s<-subset(tt1,tt1$面签操作人==c[i,])
  av<-as.numeric(mean(s$面签实际耗时))
  all1<-c(as.character(c[i,]),av)
  all<-rbind(all,all1)
}
all<-data.frame(all)

# 十分之一且时间低于20min
c1<-tt[rank(kn4)/length(kn4)<0.1,]
c2<-c1[c1$面签实际耗时<(1/3),]
write.xlsx(c2,file = "D:\\Kettle\\中转文件\\面签时效异常.xlsx",sheetName = "面签时效时长异常",append = T)
#平均值波动 
all<-NULL
for (i in 1:length(c$unique.tt1.面签操作人.)) {
  s<-subset(tt1,tt1$面签操作人==c[i,])
  av<-as.numeric(mean(s$面签实际耗时))
  all1<-s[s$面签实际耗时>=av*1.5|s$面签实际耗时<=av*0.5,]
  all<-rbind(all,all1)
}
write.xlsx(all,file = "D:\\Kettle\\中转文件\\面签时效异常.xlsx",sheetName = "面签平均时效异常",append = T)

# 
# # 分布
# test<-tt[c("面签操作人","面签实际耗时")]
# test<-test[!is.na(test$面签实际耗时),]
# # 基函数
# ggplot(test, aes(x = 面签实际耗时)) +
#   # 直方图函数：binwidth设置组距
#   geom_histogram(binwidth = 1, fill = "lightblue", colour = "black")





