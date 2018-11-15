# 加载包和工具
# google浏览器插件selector gadget
# 网页ctrl+shift+c观察HTML明细
library('rvest')

# 指定要爬取的url
url <- "https://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature"

# 从网页读取html代码
webpage <- read_html(url)
# 用CSS选择器获取排名部分
rank_data_html <- html_nodes(webpage,'.text-primary')

# 把排名转换为文本
rank_data <- html_text(rank_data_html)

# 数据预处理：把排名转换为数值型
rank_data<-as.numeric(rank_data)

# 爬取标题
title_data_html <- html_nodes(webpage,'.lister-item-header a')

# 转换为文本
title_data <- html_text(title_data_html)

# 爬取描述
description_data_html <- html_nodes(webpage,'.ratings-bar+ .text-muted')

# 转为文本
description_data <- html_text(description_data_html)

# 移除 '\n'
description_data<-gsub("\n","",description_data)

# 爬取runtime section
runtime_data_html <- html_nodes(webpage,'.text-muted .runtime')

# 转为文本
runtime_data <- html_text(runtime_data_html)

# 数据预处理: 去除“min”并把数字转换为数值型

runtime_data <- gsub(" min","",runtime_data)
runtime_data <- as.numeric(runtime_data)

# 爬取genre
genre_data_html <- html_nodes(webpage,'.genre')

# 转为文本
genre_data <- html_text(genre_data_html)

# 去除“\n”
genre_data<-gsub("\n","",genre_data)

# 去除多余空格
genre_data<-gsub(" ","",genre_data)

# 每部电影只保留第一种类型
genre_data<-gsub(",.*","",genre_data)

# 转化为因子
genre_data<-as.factor(genre_data)

# 爬取IMDB rating
rating_data_html <- html_nodes(webpage,'.ratings-imdb-rating strong')

# 转为文本
rating_data <- html_text(rating_data_html)

# 转为数值型
rating_data<-as.numeric(rating_data)

# 爬取votes section
votes_data_html <- html_nodes(webpage,'.sort-num_votes-visible span:nth-child(2)')

# 转为文本
votes_data <- html_text(votes_data_html)

# 移除“，”
votes_data<-gsub(",", "", votes_data)

# 转为数值型
votes_data<-as.numeric(votes_data)

# 爬取directors section
directors_data_html <- html_nodes(webpage,'.text-muted+ p a:nth-child(1)')

# 转为文本
directors_data <- html_text(directors_data_html)

# 转为因子
directors_data<-as.factor(directors_data)

# 爬取actors section
actors_data_html <- html_nodes(webpage,'.lister-item-content .ghost+ a')

# 转为文本
actors_data <- html_text(actors_data_html)

# 转为因子
actors_data<-as.factor(actors_data)

# 爬取metascore section
metascore_data_html <- html_nodes(webpage,'.metascore')

# 转为文本
metascore_data <- html_text(metascore_data_html)

# 去除多余空格
metascore_data<-gsub(" ","",metascore_data)

for (i in c(39,73,80,89)){
  a <- metascore_data[1:(i-1)]
  b<-metascore_data[i:length(metascore_data)]
  metascore_data <- append(a, list("NA"))
  metascore_data <- append(metascore_data, b)
}

# 转换为数值型
metascore_data <- as.numeric(metascore_data)

# 爬取revenue section
gross_data_html <- html_nodes(webpage,'.ghost~ .text-muted+ span')

# 转为文本
gross_data <- html_text(gross_data_html)

# 去除'$' 和 'M' 标记
gross_data <- gsub("M", "", gross_data)
gross_data <- substring(gross_data, 2, 6)

# 填充缺失值
for (i in c(25,38,48,50,70,85,88,92,98,100)){
  a <- gross_data[1:(i-1)]
  b <- gross_data[i:length(gross_data)]
  gross_data <- append(a, list("NA"))
  gross_data <- append(gross_data, b)}

# 合并所有list来创建一个数据框
movies_df <- data.frame(
  Rank = rank_data, 
  Title = title_data,
  Description = description_data, 
  Runtime = runtime_data,
  Genre = genre_data, 
  Rating = rating_data,
  Metascore = metascore_data, 
  Votes = votes_data,                           
  # Gross_Earning_in_Mil = gross_data,
  Director = directors_data, 
  Actor = actors_data
)
# 数据展示
library('ggplot2')
# Question 1: ** 那个类型的电影市场最长？
qplot(data = movies_df,Runtime,fill = Genre,bins = 30)

# Question 2: ** 市场130-160分钟的电影里，哪一类型东西好评率最高？
ggplot(movies_df,aes(x=Runtime,y=Rating))+
  geom_point(aes(size=Votes,col=Genre))

# Question 3: ** 100-120分钟的电影中，哪类作品的票房成绩最好
ggplot(movies_df,aes(x=Runtime,y=Gross_Earning_in_Mil))+
  geom_point(aes(size=Rating,col=Genre))