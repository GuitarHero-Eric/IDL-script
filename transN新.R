#转换函数
loadN<-function(date="today",mode=1)
{if (date=="today")
{aa<-as.character(format(Sys.Date(),"%Y%m%d"))}else{aa<-as.character(date)}
  
  if (mode==1)
  {a1<-read.csv(paste("XYD_NEW",aa,".csv",sep=""),quote = "",stringsAsFactors = F)
  a2<-gsub("X.","",colnames(a1))
  colnames(a1)<-a2
  b<-as.vector(as.character(colnames(a1)))
  b<-chartr("."," ",b)
  b<-gsub(" ","",b)
  colnames(a1)<-b
  colnames(a1)<-gsub("初审机审","",colnames(a1))
  colnames(a1)<-gsub("预审面签","",colnames(a1))
  colnames(a1)<-gsub("面签面签助理","",colnames(a1))
  
  } else {
    if (mode==2)
    {a1<-read.csv(paste("XYD",aa,".csv",sep=""),stringsAsFactors = F)
    a1$首逾标识<-gsub("首一逾",1,a1$首逾标识)
    a1$首逾标识<-gsub("首二逾",2,a1$首逾标识)
    a1$首逾标识<-gsub("首三逾",3,a1$首逾标识)
    a1$首逾标识<-gsub("首四逾",4,a1$首逾标识)
    a1$首逾标识<-gsub("首五逾",5,a1$首逾标识)
    a1$首逾标识<-gsub("首六逾",6,a1$首逾标识)
    }}
  return(a1)}