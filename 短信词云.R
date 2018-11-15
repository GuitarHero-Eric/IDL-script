library(jiebaR)
library(wordcloud)
library(wordcloud2)
f = read.csv('短信.csv', sep=',')
seg <- qseg[as.character(f$内容)] #使用qseg类型分词，并把结果保存到对象seg中
seg1 <- seg[nchar(seg)>1] #去除字符长度小于2的词语
seg1 <- seg1[!grepl('[0-9]+',seg1)]#去除数字 
seg1 <- seg1[!grepl('[a-z]+',seg1)] #去除小写字母
seg1 <- seg1[!grepl('[A-Z]+',seg1)] #去除大写字母
# text <- gsub('[a-zA-Z0-9]','',seg1)
seg2 <- table(seg1) #统计词频
length(seg2) #查看处理完后剩余的词数
seg3 <- sort(seg2, decreasing = TRUE)[1:100] #降序排序，并提取出现次数最多的前100个词语
seg3 #查看100个词频最高的
data<-data.frame(seg3)  
wordcloud2(data)
wordcloud2(word_freq,figPath='bird.png',size=0.5,shape='star',fontFamily="微软雅黑")

wordcloud(data$seg1 , data$Freq, colors = rainbow(100), random.order=F)
x11()
dev.off()
wordcloud() 

# 新易贷客户画像词云
a<-loadN(date = "20180627")
a<-subset(a,a$产品名称=="新易贷信用贷款")
# a1<-a[c("区域中心","受理城市","客群","受雇类型","家庭住址","工作地址","单位名称","性别","年龄","学历")]
a1<-a[c("区域中心","受理城市","客群","受雇类型","性别","年龄","学历")]
seg <- qseg[as.character(a1)] #使用qseg类型分词，并把结果保存到对象seg中
seg1 <- seg[nchar(seg)>1] #去除字符长度小于2的词语
seg1 <- gsub('[a-zA-Z0-9]','',seg1)
seg1 <- gsub('[-,--]','',seg1)
seg1 <- sort(seg1, decreasing = TRUE) #降序排序，并提取出现次数最多的前100个词语
seg2 <- data.frame(table(seg1)) #统计词频
seg3<-seg2[seg2$Freq>50,]
seg3<-seg3[order(seg3$Freq,decreasing = T),]
edit(seg3)
cloud()
write.csv(seg3,"新易贷信用贷.csv")
seg3<-read.csv("新易贷信用贷.csv")
seg3<-seg3[,c(2,3)]
seg3<-seg3[c(1:30),]
wordcloud2(seg3)



wk = worker()
seg1<-wk[as.character(f$内容)]
