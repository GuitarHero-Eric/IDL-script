library("xlsx")
# ���ڿͻ�����
setwd("D:\\Kettle\\��ת�ļ�")
library(RODBC)
# ��ǰ�����ܱ�
con<-odbcConnect("shengchan",uid="BPMda",pwd="password",believeNRows=FALSE)
a<-sqlQuery(con,"select * from ��ǰ�����ܱ�")
# 1����ƻ���
con1<-odbcConnect("plcsda",uid="plcsda",pwd="password",believeNRows=FALSE)
b<-sqlQuery(con1,"SELECT REPP_CONTRACT_NO �������,REPP_REPAY_DUE_DATE Ӧ��������,REPP_DUE_PRIN_AMT Ӧ������,REPP_DUE_INT_AMT Ӧ����Ϣ,
            REPP_DUE_OVD_INT_AMT Ӧ����Ϣ,REPP_DUE_OVD_FEE_AMT Ӧ�����ɷ�,REPP_UNPAY_PRIN_AMT ����δ������,
            REPP_UNPAY_INT_AMT ����δ����Ϣ,REPP_UNPAY_OVD_INT_AMT ����δ����Ϣ,REPP_UNPAY_OVD_FEE_AMT ����δ�����ɽ�
            from PLCS.t_plcs_repay_plan 
            WHERE  REPP_UNPAY_OVD_INT_AMT>0
            AND to_date(REPP_REPAY_DUE_DATE,'yyyy/MM/dd')<=to_date(to_char(sysdate,'yyyymmdd'),'yyyy/mm/dd')
            ")
due_cus<-merge(b,a,by="�������",all.x=TRUE)
# 2��ݱ�
c<-sqlQuery(con1,"SELECT DUEB_CONTRACT_NO �������,DUEB_CURR_PRIN_AMT ʣ�౾��,DUEB_CURR_INT_AMT ʣ����Ϣ 
            FROM PLCS.t_plcs_duebill_info")
# 3��ͬ��
d<-sqlQuery(con1,"SELECT CONT_CONTRACT_NO �������,CONT_CAPITAL_NAME �ʷ����� FROM PLCS.t_plcs_contract_info")
due_cus<-merge(due_cus,c,by="�������",all.x=TRUE)
due_cus<-merge(due_cus,d,by="�������",all.x=TRUE)
due_cus<-due_cus[,c("�������","����֤��","�ͻ�����","�ʷ�����","Ӧ��������","Ӧ������","Ӧ����Ϣ","Ӧ����Ϣ",
                    "Ӧ�����ɷ�","����δ������","����δ����Ϣ","����δ����Ϣ","����δ�����ɽ�","ʣ�౾��","ʣ����Ϣ")]
due_cus$δ���ϼ�<-sum(due_cus$����δ������,due_cus$����δ����Ϣ,due_cus$����δ����Ϣ,due_cus$����δ�����ɽ�)
write.xlsx(due_cus,file = "���ڿͻ�����.xlsx",sheetName = "���ڿͻ�",append = T)
# �����ͻ�����
# �۱���
due_cus_jbh<-subset(due_cus,due_cus$�ʷ�����=="�۱���")
due_cus_jbh$Ӧ��������<-as.Date(as.character(due_cus_jbh$Ӧ��������),"%Y%m%d")
due_cus_jbh_COMPST<-subset(due_cus,difftime(Sys.Date(),due_cus_jbh$Ӧ��������,units = "days")>=3)
due_cus_jbh_COMPST<-due_cus_jbh_COMPST[,c("�������","�ͻ�����","�ʷ�����","����δ������","����δ����Ϣ")]
due_cus_jbh_COMPST$�����ϼ�<-sum(due_cus$����δ������,due_cus$����δ����Ϣ)
write.xlsx(due_cus_jbh_COMPST,file = "�����ͻ�����.xlsx",sheetName = "�۱���",append = T)
close(con)
close(con1)