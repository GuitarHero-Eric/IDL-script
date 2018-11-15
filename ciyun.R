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
# �ֶ�      ��������                        ��;
# id     ����  Ψһ��ʶ         ���������ݿ�������������ƣ����ڴ���������
# title       ��λ����      ����������Ϊ��λ�ı�ʶ��������͸�λ������ϳ�Ψһ��ʶ
# company     ��˾����    ������������Ϊ�����ı�ʶ
# salary      ƽ����н(k)  �������� ����ƽ����н�ķ���
# city        �������ڳ���    ���������ڷ�������
# scale       ��ģ     ����  ����������������ҵ��ָ��
# phase       ����/��չ�׶�   ����������������ҵ��ָ��
# experience  ְλ����Ҫ��    �������������������Ӱ��
# education   ѧ��Ҫ��     ������������ѧ����Ӱ��
# description ְλ����      �����������ı��ھ�����λ�����ܷ���


str(CN.df)
# �鿴�Ƿ���ȱʧֵ,�Լ����ú����Ķ���
# �鿴�Ƿ���ȱʧֵ
aggr(CN.df,prop=T,numbers=T)

# ���طִ�Ƶ����������
top.freq <- function(x,topn=0){
  require(plyr)
  top.df <- count(x) 
  top.df <- top.df[order(top.df$freq,decreasing = TRUE),]
  if(topn > 0) return(top.df[1:topn,])
  else  return(top.df)
}

# ����
reorder_size <- function(x,decreasing=T){
  factor(x,levels = names(sort(table(x),decreasing=decreasing)))
}

# ggplot�Զ�������
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

# ��ͼչʾ
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

# ������ϴ����
cleaning <- function(my.data){
  # ȥ���ظ�ֵ
  my.data <- my.data[!duplicated(my.data[c('title','campany','description')]),]
  # ����ƽ����н
  max_sal <- as.numeric(sub('([0-9]*).*','\\1',my.data$salary))
  min_sal <- as.numeric(sub('.*-([0-9]*).*','\\1',my.data$salary))
  my.data$avg_sal <- (max_sal+min_sal)/2
  
  #��������Ҫ���ַ�,����Ҫ�������ַ�ת��������
  my.data$city <- factor(gsub('[/]*','',my.data$city))
  
  my.data$experience <- gsub('����|[/ ]*','',my.data$experience)
  my.data$experience[my.data$experience %in% c('����','Ӧ���ҵ��')] <- '1������'
  my.data$experience<- factor(my.data$experience,
                              levels = c('1������','1-3��','3-5��','5-10��','10������'))
  my.data$education <- gsub('ѧ��|������|[/ ]*','',my.data$education)
  my.data$education[my.data$education == '����'] <- '��ר'
  my.data$education <- factor(my.data$education,
                              levels = c('��ר','����','˶ʿ'))
  my.data$phase <- factor(gsub('[\n]*','',my.data$phase),
                          levels=c('����Ҫ����','δ����','��ʹ��','A��','B��','C��','D�ּ�����','���й�˾'))
  my.data$campany <- gsub('[\n| ]*','',my.data$campany)
  my.data$scale <- factor(gsub('.*(����15��|15-50��|50-150��|150-500��|500-2000��|2000������).*',
                               '\\1',paste(my.data$scale,my.data$scale2)),
                          levels =c("����15��","15-50��","50-150��","150-500��","500-2000��","2000������"))
  my.data$id <- index(my.data)
  my.data <- droplevels(subset(my.data,select=-scale2))
  return(my.data)
}

CN.clean <- cleaning(CN.df)
str(CN.clean)

# ��ʼ���зִ�ͳ��
# ����Ĭ�ϵ�jieba�ִ���
engine <- worker(user = 'E://Udacity//R//R-3.4.3//library//jiebaRD//dict//user.dict.utf8',encoding = 'UTF-8')
# ȥ���޹صĴ�
word.lis <- lapply(CN.clean$description, function(x){
  v <- gsub('[\u4e00-\u9fa5|0-9|\\.|\\-]','',segment(x,engine))
  v <- v[v!='']
  return(v)
})
# ���еĴ���ת���ɴ�д,������ִ�Сд�Ĵ���
segWord <- toupper(unlist(word.lis))
# ����stop�����б�
stopWords <- toupper(readLines('E://Udacity//R//R-3.4.3//library//jiebaRD//dict//stop_words.utf8',encoding = 'UTF-8'))

# ���˷ִ�
# �˴�ȷ����Ҫ�õ���ǰ15���ؼ���������ȷ�����ݷ�������
removewords <- function(targetword,stopword){
  targetword = targetword[targetword%in%stopword == F]
  return(targetword)
}

segword<- sapply(X=segWord, FUN = removewords,stopWords)

word_freq <- top.freq(unlist(segword),15)

# ����id��keyword���������ݿ�
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

#��ȡ�Ǽ����͹ؼ���
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
#�γɴ�Ƶ��
not.tool.keyword <- top.freq(keyword.lis)
str(not.tool.keyword)