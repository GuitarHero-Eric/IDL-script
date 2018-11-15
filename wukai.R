b<-loadX(date = "20180627")

b1<-subset(b,b$进件日期.>=as.Date("2016-01-01")&b$进件日期.<=as.Date("2016-12-31"))
b2<-subset(b1,b1$放贷金额.>0)
b2<-subset(b2,b2$推荐城市.=="成都市"|b2$推荐城市.=="郑州市"|b2$推荐城市.=="济南市"|b2$推荐城市.=="深圳市"|b2$推荐城市.=="苏州市"|b2$推荐城市.=="石家庄市")
b2$月份<-substr(b2$进件日期.,6,7)
b3<-ddply(b2,.(区域中心.),summarize,放款额=sum (放贷金额.,na.rm=TRUE)/100000000,放款数=length(放贷金额.))
b4<-ddply(b2,.(区域中心.,推荐城市.),summarize,放款额=sum (放贷金额.,na.rm=TRUE)/100000000,放款数=length(放贷金额.))
b5<-ddply(b2,.(区域中心.,推荐城市.,月份,推荐渠道.),summarize,放款额=sum (放贷金额.,na.rm=TRUE)/100000000,放款数=length(放贷金额.))           
b6<-ddply(b2,.(区域中心.,推荐城市.,月份),summarize,放款额=sum (放贷金额.,na.rm=TRUE)/100000000,放款数=length(放贷金额.))  
write.xlsx(b3,"16-17放款情况.xlsx",sheetName = "17区域中心",append = T)
write.xlsx(b4,"16-17放款情况.xlsx",sheetName = "17城市",append = T)
write.xlsx(b5,"16-17放款情况.xlsx",sheetName = "17渠道",append = T)
write.csv(b5,"17渠道.csv")
write.csv(b6,"17渠道1.csv")
b1<-subset(b,b$进件日期.>=as.Date("2016-01-01")&b$进件日期.<=as.Date("2016-12-31"))
b2<-subset(b1,b1$放贷金额.>0)
b3<-ddply(b2,.(区域中心.),summarize,放款额=sum (放贷金额.,na.rm=TRUE)/100000000,放款数=length(放贷金额.))
b4<-ddply(b2,.(区域中心.,推荐城市.),summarize,放款额=sum (放贷金额.,na.rm=TRUE)/100000000,放款数=length(放贷金额.))
b5<-ddply(b2,.(区域中心.,推荐城市.,推荐渠道.),summarize,放款额=sum (放贷金额.,na.rm=TRUE)/100000000,放款数=length(放贷金额.))             
write.xlsx(b3,"16-17放款情况.xlsx",sheetName = "16区域中心",append = T)
write.xlsx(b4,"16-17放款情况.xlsx",sheetName = "16城市",append = T)
write.xlsx(b5,"16-17放款情况.xlsx",sheetName = "16渠道",append = T)

file.remove("16-17放款情况.xlsx")

write.csv(b5,"wukai.csv")
library("xlsx")
getwd()

# 渠道6/12月后贷后情况
b<-loadX(date = "20180627")
b1<-b[c("进件日期.","推荐渠道.","本金余额.","逾期阶段.","逾期天数.","区域中心.")]
b1$推荐渠道.[b1$推荐渠道.=="凯通"]="凯通金服"
b2<-subset(b1,b1$推荐渠道.=="千业财富"|b1$推荐渠道.=="融祥"|b1$推荐渠道.=="凯通金服"|b1$推荐渠道.=="凯通"|b1$推荐渠道.=="博泉")
min(b2$进件日期.[b2$推荐渠道.=="凯通金服"])
b3<-subset(b2,as.Date(b2$进件日期.)>=as.Date("2017-05-01")&as.Date(b2$进件日期.)<=as.Date("2017-05-31"))
w<-b3
w1<-unique(w[c("推荐渠道.")])
final<-NULL
for (i in c(1:length(w1$推荐渠道.))) {
  w2<-subset(w,w$推荐渠道.==w1[i,])
  贷款余额<-sum(w2$本金余额,na.rm=TRUE)
  w3<-subset(w2,w2$逾期天数>0)
  逾期本金余额<-sum(w3$本金余额,na.rm=TRUE)
  逾期率<-逾期本金余额/贷款余额
  w4<-subset(w2,w2$逾期天数>90)
  不良贷款余额<-sum(w4$本金余额,na.rm=TRUE)
  不良率<-不良贷款余额/贷款余额
  c<-cbind(as.character(w1[i,1]),贷款余额,逾期本金余额,逾期率,不良贷款余额,不良率)
  final<-rbind(final,c)
}
write.csv(final,"各渠道存量12.csv")