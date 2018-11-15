library(RODBC)
library(plyr)
con<-odbcConnect("shengchan",uid="BPMda",pwd="password",believeNRows=FALSE)
a<-sqlQuery(con,"select * from 管理端贷前进件日维度")
x<-1
# 上一工作日
day<-subset(a,as.Date(a$日期,tz= "asia/shanghai")==Sys.Date()-x)
# 上周
week<-subset(a,as.Date(a$日期,tz= "asia/shanghai")>=Sys.Date()-8)
# 上月
month<-subset(a,as.Date(a$日期,tz= "asia/shanghai")>=Sys.Date()-31)
# 上年
year<-subset(a,as.Date(a$日期,tz= "asia/shanghai")>=Sys.Date()-366)
# 日按产品统计
day1<-ddply(day,.(受理中心,推荐机构名称,产品名称),summarize,放款金额=sum(放款金额,na.rm=T),新增申请数=sum(新增申请数,na.rm=T),
      放款时长=sum(放款时长,na.rm=T)/sum(结案数,na.rm=T)/60,通过率=sum(结案数,na.rm=T)/sum(新增申请数,na.rm=T),
      退补件数=sum(退补件数),积压件数=sum(积压件数))
day1<-cbind("日",day1)
colnames(day1)<-c("",colnames(day1)[2:8])
day1<-ddply(day,.(产品名称),summarize,放款金额=sum(放款金额,na.rm=T),新增申请数=sum(新增申请数,na.rm=T),
            放款时长=sum(放款时长,na.rm=T)/sum(结案数,na.rm=T)/60,通过率=sum(新增申请数,na.rm=T)/sum(退补件数,na.rm=T),
            退补件数=sum(退补件数),积压件数=sum(积压件数))
day1<-cbind("日",day1)
colnames(day1)<-c("",colnames(day1)[2:8])






week1<-ddply(week,.(产品名称),summarize,放款金额=sum(放款金额,na.rm=T),新增申请数=sum(新增申请数,na.rm=T),
      放款时长=sum(放款时长,na.rm=T)/sum(结案数,na.rm=T)/60,通过率=sum(新增申请数,na.rm=T)/sum(退补件数,na.rm=T),
      退补件数=sum(退补件数),积压件数=sum(积压件数))
week1<-cbind("周",week1)
colnames(week1)<-c("",colnames(week1)[2:8])
month1<-ddply(month,.(产品名称),summarize,放款金额=sum(放款金额,na.rm=T),新增申请数=sum(新增申请数,na.rm=T),
      放款时长=sum(放款时长,na.rm=T)/sum(结案数,na.rm=T)/60,通过率=sum(新增申请数,na.rm=T)/sum(退补件数,na.rm=T),
      退补件数=sum(退补件数),积压件数=sum(积压件数))
year1<-ddply(year,.(产品名称),summarize,放款金额=sum(放款金额,na.rm=T),新增申请数=sum(新增申请数,na.rm=T),
      放款时长=sum(放款时长,na.rm=T)/sum(结案数,na.rm=T)/60,通过率=sum(新增申请数,na.rm=T)/sum(退补件数,na.rm=T),
      退补件数=sum(退补件数),积压件数=sum(积压件数))
all1<-rbind(day1,week1)
