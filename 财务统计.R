library(RODBC)
con1<-odbcConnect("plcsda",uid="plcsda",pwd="password",believeNRows=FALSE)
a1<-sqlQuery(con1,"SELECT * FROM PLCS.T_PLCS_JBH_LOAN_REPLY")
a1<-a1[c("PLATFORM_PROJECT_ID","REAL_AMOUNT")]
colnames(a1)<-c("进件编号","放款金额")
con<-odbcConnect("shengchan",uid="BPMda",pwd="password",believeNRows=FALSE)
b<-sqlQuery(con,"select * from 贷前进件总表")
c<-merge(a1,b,by= "进件编号",all.x = TRUE)
c1<-c[c("进件编号","受理中心","资方机构","产品名称","客户姓名","放款金额","放款时间")]
write.csv(c1,"放款明细.csv")
