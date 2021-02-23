# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  Sanofi CHC 2020Q4
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
chpa.2020q4 <- read.xlsx('02_Inputs/ims_chpa_to20Q4_fmt.xlsx')

## VBP
vbp.raw <- read.xlsx('02_Inputs/VBP中标产品信息0125.xlsx', sheet = 2) %>% 
  filter(!is.na(`VBP通用名`), !is.na(`中标pack`))


##---- History delivery ----
history.sanofi.lantus <- read.xlsx('06_Deliveries/lantus_chc_2018Q1_2020Q3_1120.xlsx', check.names = FALSE)
history.sanofi.plavix <- read.xlsx('06_Deliveries/plavix_chc_2018Q1_2020Q3_1211.xlsx', check.names = FALSE)

