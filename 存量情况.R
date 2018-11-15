w<-loadW(date = "2018-06-27")
a<-loadX(date = 20180627)
t<-merge(w,a,by.x = "进件编号",by.y = "申请编号.",all.x = TRUE)
w<-t
w1<-unique(w[c("推荐渠道.")])
final<-NULL
for (i in c(1:length(w1$推荐渠道.))) {
  w2<-subset(w,w$推荐渠道.==w1[i,])
  贷款余额<-sum(w2$本金余额)
  w3<-subset(w2,w2$逾期天数>0)
  逾期本金余额<-sum(w3$本金余额)
  逾期率<-逾期本金余额/贷款余额
  w4<-subset(w2,w2$逾期天数>90)
  不良贷款余额<-sum(w4$本金余额)
  不良率<-不良贷款余额/贷款余额
  c<-cbind(as.character(w1[i,1]),贷款余额,逾期本金余额,逾期率,不良贷款余额,不良率)
  final<-rbind(final,c)
}
write.csv(final,"各渠道存量.csv")
