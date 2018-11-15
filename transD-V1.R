loadD<- function(date="today")
{
  if (date=="today")
  {date <- as.character(format(Sys.Date(),"%Y%m%d"))}else{
    date<-as.Date(date)
    date <- as.character(format(date,"%Y%m%d"))}
  if (is.na(file.info(paste("lab/LOAN_OVD_CUST_DAY_INFO_","0",1,"_",date,".csv",sep=""))$size)) {
  #�����ļ���
  customerfile <- paste("LOAN_OVD_CUST_DAY_INFO_",date,".zip",sep="")
  #���ص����ļ�
  download.file(paste("ftp://yunying:YYftp%232015@172.16.6.238/",customerfile,sep=""),customerfile)
  #��ѹ�ļ�
  unzip(customerfile,exdir = "lab")
  #ɾ��ѹ���ļ�
  file.remove(customerfile)
  }
  a <- c(0)
  for (i in a) {
    customerfilecsv <- paste("LOAN_OVD_CUST_DAY_INFO_01_",date,".csv",sep = "")
    customerfilecsv <- paste("lab/",customerfilecsv,sep="")
    xt1 <- read.csv(customerfilecsv,quote = "",stringsAsFactors = FALSE)
    if (i==0)
    {xtt <- xt1}
    else
    {xtt <- rbind(xtt,xt1)}
  }
  if (is.na(file.info(paste("lab/LOAN_OVD_CUST_DAY_INFO_","0",2,"_",date,".csv",sep=""))$size) ==F){
    xt1 <- read.csv(paste("lab/LOAN_OVD_CUST_DAY_INFO_","0",2,"_",date,".csv",sep=""))
    xtt <- rbind(xtt,xt1)
  }
  colnames(xtt)<-gsub("X.","",colnames(xtt))
  b<-as.vector(as.character(colnames(xtt)))
  b<-chartr("."," ",b)
  b<-gsub(" ","",b)
  colnames(xtt)<-b
  xtt$���ѽ����˺�<-gsub("=","",xtt$���ѽ����˺�)
  xtt$���ѽ����˺�<-gsub("\"","",xtt$���ѽ����˺�)
  product_clsssify <- paste("ģ��/","�ָ��Ʒ����",".CSV",sep="")
  product_clsssify <- read.csv(product_clsssify)
  # 
  # city_clsssify <- paste("ģ��/","�ָ��������",".CSV",sep="")
  # city_clsssify <- read.csv(city_clsssify)
  xtt <- merge(xtt,product_clsssify,by="��Ȳ�Ʒ",all.x=T)
  # xtt <- merge(xtt,city_clsssify,by="��������",all.x=T)
  return(xtt)
}