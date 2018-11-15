loaninvest<-function(A=10000,m=24,i=0.24/12)
{
  # # 贷款总金额
  # A<-10000
  # # 月利率
  # i<-0.24/12
  # # 贷款期数
  # m<-24
  a<-A
  d<-1+i
  j<-c(1:m)
  # 每月还款额
  R1<-A*i*(1+i)^(m)/((1+i)^(m)-1)
  P<-NULL
  # 第二期利息
  (A-R1*j)*i
  i[j+1]<-A*(1+i)^(j)*i-R1*((1+i)^(j)-1)
  i[1]<-A*(d-1)
  P[1]<-R1-i[1]
  P[j]<-R1-i[j]
  A[j]<-a*d^(j)-R1*(d^(j)-1)/(d-1)
  R1#等额偿还金额
  I<-sum(i[j])
  I#总利息和
  P1<-round(P[j],2)#第j期还款本金
  A1<-round(A[j],2)#第j期贷款余额
  I1<-round(i[j],2)#第j期还款利息
  R1<-round(R1,2)#还款金额
  loan<-data.frame(还款本金P1=P1,还款利息I1=I1,贷款余额A1=A1,还款金额R1=R1)
  return(loan)
}
# write.table(loan,file="E:\\loan.txt")
# loan<-read.table("E:\\loan.txt",header=T)
# write.csv(loan,"E:\\loan.csv")
# read.csv("E:\\loan.csv")
rich<-function(x=10,y=20,r=0.1)
{
  final=0
  final1=0
  # bi指第i期时收到的还款假设全放出
  b0<-0
  for (i in c(0:y)) {
    z=x*(1+r)^i
    final=final+z
    z1<-print(assign(paste("b",i+1,sep = ""), final))
    final1<-final1+z1
  }
  # return(final)
  return(final1)
}

25000000*0.12/4
75万
75000000*0.1/4
187.5万
合计262.5万

# 一年
25000000*0.12+75000000*0.1
1050万
c<-rich(x=528.710973,y=24,r=0.1347151595/12)
