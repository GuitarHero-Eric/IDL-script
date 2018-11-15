loadW<- function (date="today") {
  if (date=="today")
  {date <- as.character(format(Sys.Date(),"%Y%m%d"))}else{
    date<-as.Date(date)
    date <- as.character(format(date,"%Y%m%d"))}
  if (is.na(file.info(paste("daily_report/客户产品余额五级分类日报",date,"_",0,".csv",sep=""))$size )) {
    customerfile <- paste("客户产品余额五级分类日报_",date,".zip",sep="")
    #定义文件名
    download.file(paste("ftp://fengxian:fengxian@172.16.6.238/",customerfile,sep=""),customerfile)
    #下载当日文件
    unzip(customerfile,exdir = "daily_report")
    #解压文件
    file.remove(customerfile)
  }
  for (i in c(0,1)) {
    customerfilecsv <- paste("daily_report/客户产品余额五级分类日报",date,"_",i,".csv",sep="")
    xt1 <- read.csv(customerfilecsv)
    if (i==0)
    {xtt <- xt1}
    else
    {xtt <- rbind(xtt,xt1)}
  }
  if (is.na(file.info(paste("daily_report/客户产品余额五级分类日报",date,"_",2,".csv",sep=""))$size) ==F){
    xt1 <- read.csv(paste("daily_report/客户产品余额五级分类日报",date,"_",2,".csv",sep=""))
    xtt <- rbind(xtt,xt1)
  }
  
  product_clsssify <- paste("模板/","贾哥产品归类",".CSV",sep="")
  product_clsssify <- read.csv(product_clsssify)
  
  city_clsssify <- paste("模板/","贾哥区域城市",".CSV",sep="")
  city_clsssify <- read.csv(city_clsssify)
  xtt <- merge(xtt,product_clsssify,by="额度产品",all.x=T)
  xtt <- merge(xtt,city_clsssify,by="受理区域",all.x=T)
  xtt$证件号码<-gsub("=","",xtt$证件号码)
  return(xtt)
}