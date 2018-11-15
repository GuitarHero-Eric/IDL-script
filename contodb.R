library("xlsx")
# 逾期客户名单
setwd("D:\\Kettle\\中转文件")
library(RODBC)
# 贷前进件总表
con<-odbcConnect("shengchan",uid="BPMda",pwd="password",believeNRows=FALSE)
a<-sqlQuery(con,"select * from 贷前进件总表")
# 1还款计划表
con1<-odbcConnect("plcsda",uid="plcsda",pwd="password",believeNRows=FALSE)
b<-sqlQuery(con1,"SELECT REPP_CONTRACT_NO 进件编号,REPP_REPAY_DUE_DATE 应还款日期,REPP_DUE_PRIN_AMT 应还本金,REPP_DUE_INT_AMT 应还利息,
            REPP_DUE_OVD_INT_AMT 应还罚息,REPP_DUE_OVD_FEE_AMT 应还滞纳费,REPP_UNPAY_PRIN_AMT 当期未还本金,
            REPP_UNPAY_INT_AMT 当期未还利息,REPP_UNPAY_OVD_INT_AMT 当期未还罚息,REPP_UNPAY_OVD_FEE_AMT 当期未还滞纳金
            from PLCS.t_plcs_repay_plan 
            WHERE  REPP_UNPAY_OVD_INT_AMT>0
            AND to_date(REPP_REPAY_DUE_DATE,'yyyy/MM/dd')<=to_date(to_char(sysdate,'yyyymmdd'),'yyyy/mm/dd')
            ")
due_cus<-merge(b,a,by="进件编号",all.x=TRUE)
# 2借据表
c<-sqlQuery(con1,"SELECT DUEB_CONTRACT_NO 进件编号,DUEB_CURR_PRIN_AMT 剩余本金,DUEB_CURR_INT_AMT 剩余利息 
            FROM PLCS.t_plcs_duebill_info")
# 3合同表
d<-sqlQuery(con1,"SELECT CONT_CONTRACT_NO 进件编号,CONT_CAPITAL_NAME 资方名称 FROM PLCS.t_plcs_contract_info")
due_cus<-merge(due_cus,c,by="进件编号",all.x=TRUE)
due_cus<-merge(due_cus,d,by="进件编号",all.x=TRUE)
due_cus<-due_cus[,c("进件编号","身份证号","客户姓名","资方名称","应还款日期","应还本金","应还利息","应还罚息",
                    "应还滞纳费","当期未还本金","当期未还利息","当期未还罚息","当期未还滞纳金","剩余本金","剩余利息")]
due_cus$未还合计<-sum(due_cus$当期未还本金,due_cus$当期未还利息,due_cus$当期未还罚息,due_cus$当期未还滞纳金)
write.xlsx(due_cus,file = "逾期客户名单.xlsx",sheetName = "逾期客户",append = T)
# 代偿客户名单
# 聚宝汇
due_cus_jbh<-subset(due_cus,due_cus$资方名称=="聚宝汇")
due_cus_jbh$应还款日期<-as.Date(as.character(due_cus_jbh$应还款日期),"%Y%m%d")
due_cus_jbh_COMPST<-subset(due_cus,difftime(Sys.Date(),due_cus_jbh$应还款日期,units = "days")>=3)
due_cus_jbh_COMPST<-due_cus_jbh_COMPST[,c("进件编号","客户姓名","资方名称","当期未还本金","当期未还利息")]
due_cus_jbh_COMPST$代偿合计<-sum(due_cus$当期未还本金,due_cus$当期未还利息)
write.xlsx(due_cus_jbh_COMPST,file = "代偿客户名单.xlsx",sheetName = "聚宝汇",append = T)
close(con)
close(con1)
