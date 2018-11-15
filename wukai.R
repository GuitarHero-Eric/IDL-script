b<-loadX(date = "20180627")

b1<-subset(b,b$��������.>=as.Date("2016-01-01")&b$��������.<=as.Date("2016-12-31"))
b2<-subset(b1,b1$�Ŵ����.>0)
b2<-subset(b2,b2$�Ƽ�����.=="�ɶ���"|b2$�Ƽ�����.=="֣����"|b2$�Ƽ�����.=="������"|b2$�Ƽ�����.=="������"|b2$�Ƽ�����.=="������"|b2$�Ƽ�����.=="ʯ��ׯ��")
b2$�·�<-substr(b2$��������.,6,7)
b3<-ddply(b2,.(��������.),summarize,�ſ��=sum (�Ŵ����.,na.rm=TRUE)/100000000,�ſ���=length(�Ŵ����.))
b4<-ddply(b2,.(��������.,�Ƽ�����.),summarize,�ſ��=sum (�Ŵ����.,na.rm=TRUE)/100000000,�ſ���=length(�Ŵ����.))
b5<-ddply(b2,.(��������.,�Ƽ�����.,�·�,�Ƽ�����.),summarize,�ſ��=sum (�Ŵ����.,na.rm=TRUE)/100000000,�ſ���=length(�Ŵ����.))           
b6<-ddply(b2,.(��������.,�Ƽ�����.,�·�),summarize,�ſ��=sum (�Ŵ����.,na.rm=TRUE)/100000000,�ſ���=length(�Ŵ����.))  
write.xlsx(b3,"16-17�ſ����.xlsx",sheetName = "17��������",append = T)
write.xlsx(b4,"16-17�ſ����.xlsx",sheetName = "17����",append = T)
write.xlsx(b5,"16-17�ſ����.xlsx",sheetName = "17����",append = T)
write.csv(b5,"17����.csv")
write.csv(b6,"17����1.csv")
b1<-subset(b,b$��������.>=as.Date("2016-01-01")&b$��������.<=as.Date("2016-12-31"))
b2<-subset(b1,b1$�Ŵ����.>0)
b3<-ddply(b2,.(��������.),summarize,�ſ��=sum (�Ŵ����.,na.rm=TRUE)/100000000,�ſ���=length(�Ŵ����.))
b4<-ddply(b2,.(��������.,�Ƽ�����.),summarize,�ſ��=sum (�Ŵ����.,na.rm=TRUE)/100000000,�ſ���=length(�Ŵ����.))
b5<-ddply(b2,.(��������.,�Ƽ�����.,�Ƽ�����.),summarize,�ſ��=sum (�Ŵ����.,na.rm=TRUE)/100000000,�ſ���=length(�Ŵ����.))             
write.xlsx(b3,"16-17�ſ����.xlsx",sheetName = "16��������",append = T)
write.xlsx(b4,"16-17�ſ����.xlsx",sheetName = "16����",append = T)
write.xlsx(b5,"16-17�ſ����.xlsx",sheetName = "16����",append = T)

file.remove("16-17�ſ����.xlsx")

write.csv(b5,"wukai.csv")
library("xlsx")
getwd()

# ����6/12�º�������
b<-loadX(date = "20180627")
b1<-b[c("��������.","�Ƽ�����.","�������.","���ڽ׶�.","��������.","��������.")]
b1$�Ƽ�����.[b1$�Ƽ�����.=="��ͨ"]="��ͨ���"
b2<-subset(b1,b1$�Ƽ�����.=="ǧҵ�Ƹ�"|b1$�Ƽ�����.=="����"|b1$�Ƽ�����.=="��ͨ���"|b1$�Ƽ�����.=="��ͨ"|b1$�Ƽ�����.=="��Ȫ")
min(b2$��������.[b2$�Ƽ�����.=="��ͨ���"])
b3<-subset(b2,as.Date(b2$��������.)>=as.Date("2017-05-01")&as.Date(b2$��������.)<=as.Date("2017-05-31"))
w<-b3
w1<-unique(w[c("�Ƽ�����.")])
final<-NULL
for (i in c(1:length(w1$�Ƽ�����.))) {
  w2<-subset(w,w$�Ƽ�����.==w1[i,])
  �������<-sum(w2$�������,na.rm=TRUE)
  w3<-subset(w2,w2$��������>0)
  ���ڱ������<-sum(w3$�������,na.rm=TRUE)
  ������<-���ڱ������/�������
  w4<-subset(w2,w2$��������>90)
  �����������<-sum(w4$�������,na.rm=TRUE)
  ������<-�����������/�������
  c<-cbind(as.character(w1[i,1]),�������,���ڱ������,������,�����������,������)
  final<-rbind(final,c)
}
write.csv(final,"����������12.csv")