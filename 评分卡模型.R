# klaR: Classification and Visualization
library(klaR)
# InformationValue: Performance Analysis and Companion Functions for Binary Classification Models
library(InformationValue)
data(GermanCredit)
train_kfold<-sample(nrow(GermanCredit),800,replace = F)
train_kfolddata<-GermanCredit[train_kfold,]   #提取样本数据集
test_kfolddata<-GermanCredit[-train_kfold,]   #提取测试数据集
credit_risk<-ifelse(train_kfolddata[,"credit_risk"]=="good",0,1)
train_kfolddata$credit_risk<-credit_risk

# EDA:Exploratory Data Analysis
# require(caret)
# data(GermanCredit)
# ggplot(GermanCredit, aes(x = duration,y = ..count..,)) + geom_histogram(fill = "blue", colour = "grey60", size = 0.2, alpha = 0.2,binwidth = 5)
# ggplot(GermanCredit, aes(x = amount,y = ..count..,)) + geom_histogram(fill = "blue", colour = "grey60", size = 0.2, alpha = 0.2,binwidth = 500)
# ggplot(GermanCredit, aes(x =credit_risk,y = ..count..,)) + geom_histogram(fill = "blue", colour = "grey60" , alpha = 0.2,stat="count")

# 等距分段（Equval length intervals）
# 等深分段（Equal frequency intervals）
# 最优分段（Optimal Binning）
# 最优分箱包smbinning
library(smbinning)
Durationresult=smbinning(df=train_kfolddata,y="credit_risk",x="duration",p=0.05)
CreditAmountresult=smbinning(df=train_kfolddata,y="credit_risk",x="amount",p=0.05) 
Ageresult=smbinning(df=train_kfolddata,y="credit_risk",x="age",p=0.05) 


smbinning.plot(CreditAmountresult,option="WoE",sub="CreditAmount") 
smbinning.plot(Durationresult,option="WoE",sub="Durationresult") 
smbinning.plot(Ageresult,option="WoE",sub="Ageresult")
AccountBalancewoe=woe(train, "AccountBalance",Continuous = F, "credit_risk",C_Bin = 4,Good = "1",Bad = "0")
ggplot(AccountBalancewoe, aes(x = BIN, y = -WOE)) + geom_bar(stat = "identity",fill = "blue", colour = "grey60",size = 0.2, alpha = 0.2)+labs(title = "AccountBalance")
