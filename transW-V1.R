loadW<- function (date="today") {
  if (date=="today")
  {date <- as.character(format(Sys.Date(),"%Y%m%d"))}else{
    date<-as.Date(date)
    date <- as.character(format(date,"%Y%m%d"))}
  if (is.na(file.info(paste("daily_report/�ͻ���Ʒ����弶�����ձ�",date,"_",0,".csv",sep=""))$size )) {
    customerfile <- paste("�ͻ���Ʒ����弶�����ձ�_",date,".zip",sep="")
    #�����ļ���
    download.file(paste("ftp://fengxian:fengxian@172.16.6.238/",customerfile,sep=""),customerfile)
    #���ص����ļ�
    unzip(customerfile,exdir = "daily_report")
    #��ѹ�ļ�
    file.remove(customerfile)
  }
  for (i in c(0,1)) {
    customerfilecsv <- paste("daily_report/�ͻ���Ʒ����弶�����ձ�",date,"_",i,".csv",sep="")
    xt1 <- read.csv(customerfilecsv)
    if (i==0)
    {xtt <- xt1}
    else
    {xtt <- rbind(xtt,xt1)}
  }
  if (is.na(file.info(paste("daily_report/�ͻ���Ʒ����弶�����ձ�",date,"_",2,".csv",sep=""))$size) ==F){
    xt1 <- read.csv(paste("daily_report/�ͻ���Ʒ����弶�����ձ�",date,"_",2,".csv",sep=""))
    xtt <- rbind(xtt,xt1)
  }
  
  product_clsssify <- paste("ģ��/","�ָ��Ʒ����",".CSV",sep="")
  product_clsssify <- read.csv(product_clsssify)
  
  city_clsssify <- paste("ģ��/","�ָ��������",".CSV",sep="")
  city_clsssify <- read.csv(city_clsssify)
  xtt <- merge(xtt,product_clsssify,by="��Ȳ�Ʒ",all.x=T)
  xtt <- merge(xtt,city_clsssify,by="��������",all.x=T)
  xtt$֤������<-gsub("=","",xtt$֤������)
  return(xtt)
}