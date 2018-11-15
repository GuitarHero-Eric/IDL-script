library(readxl)
library(jiebaR)
library(jiebaRD)
library(zoo)
library(VIM)
library(plyr)
library(ggplot2)
library(wordcloud2)
CN.df <- read_excel('CN_lagou_jobdata.xlsx',1)

CN.df <- CN.df[,c('title','salary','experience','education','campany','scale','scale2','description','phase','city')]
# 字段      　　描述                        用途
# id     　　  唯一标识         　　与数据库表主键功能类似，用于处理表关联
# title       岗位名称      　　　　作为岗位的标识，与雇主和岗位描述组合成唯一标识
# company     公司名称    　　　　　作为雇主的标识
# salary      平均月薪(k)  　　　　 用于平均月薪的分析
# city        工作所在城市    　　　用于分析地域
# scale       规模     　　  　　　用于区别企业的指标
# phase       融资/发展阶段   　　　用于区别企业的指标
# experience  职位经验要求    　　　分析工作经验的影响
# education   学历要求     　　　　分析学历的影响
# description 职位描述      　　　用于文本挖掘，做岗位需求技能分析


str(CN.df)
# 查看是否有缺失值,以及常用函数的定义
# 查看是否有缺失值
aggr(CN.df,prop=T,numbers=T)

# 返回分词频数表的排序
top.freq <- function(x,topn=0){
  require(plyr)
  top.df <- count(x) 
  top.df <- top.df[order(top.df$freq,decreasing = TRUE),]
  if(topn > 0) return(top.df[1:topn,])
  else  return(top.df)
}

# 排序
reorder_size <- function(x,decreasing=T){
  factor(x,levels = names(sort(table(x),decreasing=decreasing)))
}

# ggplot自定义主题
my.ggplot.theme <- function(...,bg='white'){
  require('guid')
  theme_classic(...)+
    theme(rect = element_rect(fill = bg),
          plot.title = element_text(hjust = 0.5),
          text = element_text(family = 'STHeiti'),
          panel.background = element_rect(fill='transparent', color='#333333'),
          axis.line = element_line(color='#333333',size = 0.25),
          legend.key = element_rect(fill='transparent',colour = 'transparent'),
          panel.border = element_rect(fill='transparent',colour = 'transparent'),
          panel.grid = element_line(colour = 'grey95'),
          panel.grid.major = element_line(colour = 'grey92',size = 0.25),
          panel.grid.minor = element_line(colour = 'grey92',size = 0.1))
}

# 多图展示
mutiplot <- function(...,plotlist=NULL,file,cols=1,layout=NULL){
  library(grid)
  plots <- c(list(...),plotlist)
  numPlots <- length(plots)
  if(is.null(layout)){
    layout <- matrix(seq(1,cols*ceiling(numPlots/cols)),
                     ncol = cols,
                     nrow = ceiling(numPlots/cols))
  }
  if(numPlots == 1){
    print(plot[[1]])
  }
  else{
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout),ncol(layout))))
    for(i in 1:numPlots){
      matchidx <- as.data.frame(which(layout==i,arr.ind = T))
      print(plots[[i]],vp=viewport(layout.pos.row = matchidx$row,layout.pos.col = matchidx$col))
    }
  }
}

# 数据清洗整理
cleaning <- function(my.data){
  # 去掉重复值
  my.data <- my.data[!duplicated(my.data[c('title','campany','description')]),]
  # 计算平均月薪
  max_sal <- as.numeric(sub('([0-9]*).*','\\1',my.data$salary))
  min_sal <- as.numeric(sub('.*-([0-9]*).*','\\1',my.data$salary))
  my.data$avg_sal <- (max_sal+min_sal)/2
  
  #清理不需要的字符,将需要分析的字符转换成因子
  my.data$city <- factor(gsub('[/]*','',my.data$city))
  
  my.data$experience <- gsub('经验|[/ ]*','',my.data$experience)
  my.data$experience[my.data$experience %in% c('不限','应届毕业生')] <- '1年以下'
  my.data$experience<- factor(my.data$experience,
                              levels = c('1年以下','1-3年','3-5年','5-10年','10年以上'))
  my.data$education <- gsub('学历|及以上|[/ ]*','',my.data$education)
  my.data$education[my.data$education == '不限'] <- '大专'
  my.data$education <- factor(my.data$education,
                              levels = c('大专','本科','硕士'))
  my.data$phase <- factor(gsub('[\n]*','',my.data$phase),
                          levels=c('不需要融资','未融资','天使轮','A轮','B轮','C轮','D轮及以上','上市公司'))
  my.data$campany <- gsub('[\n| ]*','',my.data$campany)
  my.data$scale <- factor(gsub('.*(少于15人|15-50人|50-150人|150-500人|500-2000人|2000人以上).*',
                               '\\1',paste(my.data$scale,my.data$scale2)),
                          levels =c("少于15人","15-50人","50-150人","150-500人","500-2000人","2000人以上"))
  my.data$id <- index(my.data)
  my.data <- droplevels(subset(my.data,select=-scale2))
  return(my.data)
}

CN.clean <- cleaning(CN.df)
str(CN.clean)

# 开始进行分词统计
# 采用默认的jieba分词器
engine <- worker(user = 'E://Udacity//R//R-3.4.3//library//jiebaRD//dict//user.dict.utf8',encoding = 'UTF-8')
# 去除无关的词
word.lis <- lapply(CN.clean$description, function(x){
  v <- gsub('[\u4e00-\u9fa5|0-9|\\.|\\-]','',segment(x,engine))
  v <- v[v!='']
  return(v)
})
# 所有的词语转化成大写,避免出现大小写的错误
segWord <- toupper(unlist(word.lis))
# 加载stop词语列表
stopWords <- toupper(readLines('E://Udacity//R//R-3.4.3//library//jiebaRD//dict//stop_words.utf8',encoding = 'UTF-8'))

# 过滤分词
# 此处确保我要得到的前15个关键技能是正确的数据分析技能
removewords <- function(targetword,stopword){
  targetword = targetword[targetword%in%stopword == F]
  return(targetword)
}

segword<- sapply(X=segWord, FUN = removewords,stopWords)

word_freq <- top.freq(unlist(segword),15)

# 成有id和keyword构建的数据框
id <- NULL
keyword <- NULL
for(i in index(word.lis)){
  id <- c(id,rep(i,length(word.lis[[i]])))
  keyword <- c(keyword,word.lis[[i]])
}
keyword.df <- data.frame("id"=id,"keyword"=toupper(keyword))
keyword.df <- droplevels(keyword.df[keyword.df$keyword %in% word_freq$x,])

merge.df <- merge(CN.clean,keyword.df,by = 'id')

summary(merge.df)

#提取非技能型关键词
keys <- worker(type = "keywords",
               user = "E://Udacity//R//R-3.4.3//library//jiebaRD//dict//user.dict.utf8",
               topn = 20,
               encoding = 'UTF-8',
               stop_word = "E://Udacity//R//R-3.4.3//library//jiebaRD//dict//stop_words.utf8")
keyword.lis <- lapply(CN.clean$description, function(x){
  v <- gsub("[a-zA-Z|0-9|\\.|\\-]","",keywords(x,keys))
  v <- v[v!=""]
  return(v)
})
keyword.lis <- unlist(keyword.lis)
#形成词频表
not.tool.keyword <- top.freq(keyword.lis)
str(not.tool.keyword)