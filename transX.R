loadX<-function(date="today",mode=1)
{if (date=="today")
{aa<-as.character(format(Sys.Date(),"%Y%m%d"))}else{aa<-as.character(date)}
  b<-read.csv(paste("现金贷款产品信息",aa,".CSV",sep = ""),stringsAsFactors = F,quote = "")
  colnames(b)<-gsub("X.","",colnames(b))
  b$额度代码.<-gsub("=","",b$额度代码.)
  b$额度代码.<-gsub("\"","",b$额度代码.)
  return(b)
}