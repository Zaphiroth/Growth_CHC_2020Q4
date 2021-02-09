# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  Growth CHC
# Purpose:      Readin
# programmer:   Zhe Liu
# Date:         2021-02-08
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


##---- Data for growth ----
## lanpishu
raw.bb <- read_csv('02_Inputs/shequ_100_bjjszj_20_packid_moleinfo.csv', 
                   locale = locale(encoding = 'GB18030'))

## Guangzhou
raw.gz.20q3 <- read_xlsx('02_Inputs/gz_广东省_2020Q3_packid_moleinfo.xlsx')
raw.gz.20q4 <- read_xlsx('02_Inputs/gz_广东省_2020Q4_packid_moleinfo.xlsx')

## CHPA
raw.chpa <- read_csv('02_Inputs/ims_chpa_packid_moleinfo_by_month_2020M11.csv')


##---- History delivery ----
history.sanofi.lantus <- read.xlsx('06_Deliveries/lantus_chc_2018Q1_2020Q3_1120.xlsx', check.names = FALSE)
history.sanofi.plavix <- read.xlsx('06_Deliveries/plavix_chc_2018Q1_2020Q3_1211.xlsx', check.names = FALSE)

