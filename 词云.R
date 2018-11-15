# 中文分词包
library(jiebaR)
# 词云
library(wordcloud)



#加载分词需要用到的包
library(tm)
library(Rwordseg)
library(wordcloud2)
library(tmcn)
#自定义词典
installDict(dictpath = ‘C:/Users/Thinkpad/Desktop/红楼梦/红楼梦诗词.scel‘,
            dictname =‘hlmsc‘, dicttype = ‘scel‘)
installDict(dictpath = ‘C:/Users/Thinkpad/Desktop/红楼梦/红楼梦群成员名字词库.scel‘,
            dictname =‘hlmname‘, dicttype = ‘scel‘)
installDict(dictpath = ‘C:/Users/Thinkpad/Desktop/红楼梦/红楼梦词汇.scel‘,
            dictname =‘hlmch‘, dicttype = ‘scel‘)
installDict(dictpath = ‘C:/Users/Thinkpad/Desktop/红楼梦/红楼词语.scel‘,
            dictname =‘hlmcy‘, dicttype = ‘scel‘)
installDict(dictpath = ‘C:/Users/Thinkpad/Desktop/红楼梦/《红楼梦》词汇大全【官方推荐】.scel‘,
            dictname = ‘hlmch‘, dicttype = ‘scel‘)
#查看已添加词典
listDict()

#添加新词可以使用函数insertWords()，这里不添加新词

#分词，对segmentCN()第一个参数对应的文本分词，并将结果返回给第二个参数对应的位置，这种方式可以节约很多时间
system.time(segmentCN(‘C:/Users/Thinkpad/Desktop/红楼梦/红楼梦.txt‘,outfile=‘C:/Users/Thinkpad/Desktop/红楼梦/word_result.txt‘,blocklines=10000))

#统计词频,加载data.table()包，提高读取速度；把上步txt格式的分词结果变为csv格式再读取
library(data.table)
fc_result=fread("C:/Users/Thinkpad/Desktop/红楼梦/word_result.csv")
word_freq=getWordFreq(string = unlist(fc_result))
#按照词频排序，排名前100的词
word_freq[1:100,]
#dim(word_freq)[1]
#过滤前10000个热词中的单字
x=rep(0,times=10000)
for(i in 1:10000){
  if(nchar(word_freq[i,])[1]>1)
    x[i]=i
}
length(x)
y=sort(x)[2930:10000]
y=word_freq[y,]
#y[1:200,]
write.table(y,file="C:/Users/Thinkpad/Desktop/红楼梦/word_result2.txt")
#去停用词
ssc=read.table("C:/Users/Thinkpad/Desktop/红楼梦/word_result2.txt",header=TRUE)
class(ssc)
ssc[1:10,]
ssc=as.matrix(ssc)
stopwords=read.table("C:/Users/Thinkpad/Desktop/红楼梦/停用词.txt")
class(stopwords)
stopwords=as.vector(stopwords[,1])
wordResult=removeWords(ssc,stopwords)
#去空格
kkk=which(wordResult[,2]=="")
wordResult=wordResult[-kkk,][,2:3]
#去停用词结果
wordResult[1:100,]
write.table(wordResult,file="C:/Users/Thinkpad/Desktop/红楼梦/wordResult.txt")
#画出词云
wordResult=read.table("C:/Users/Thinkpad/Desktop/红楼梦/wordResult.txt")
#词云以"红楼梦"的形式展示
wordcloud2(wordResult,figPath=‘C:/Users/Thinkpad/Desktop/2.jpg‘)
#词云以"石头记"的形式展示
wordcloud2(wordResult,figPath=‘C:/Users/Thinkpad/Desktop/3.jpg‘)
#词云以汉字“红楼梦”的形式展示
letterCloud(wordResult,"红楼梦")