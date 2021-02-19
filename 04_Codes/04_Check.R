# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  Growth CHC
# Purpose:      Check data
# programmer:   Zhe Liu
# Date:         2021-02-18
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


##---- Check SOP -----
# CHPA
chpa.fmt <- raw.chpa %>% 
  filter(variable %in% c('LC', 'UN', 'CU')) %>% 
  mutate(`2018Q1` = `2018M01` + `2018M02` + `2018M03`, 
         `2018Q2` = `2018M04` + `2018M05` + `2018M06`, 
         `2018Q3` = `2018M07` + `2018M08` + `2018M09`, 
         `2018Q4` = `2018M10` + `2018M11` + `2018M12`, 
         `2019Q1` = `2019M01` + `2019M02` + `2019M03`, 
         `2019Q2` = `2019M04` + `2019M05` + `2019M06`, 
         `2019Q3` = `2019M07` + `2019M08` + `2019M09`, 
         `2019Q4` = `2019M10` + `2019M11` + `2019M12`, 
         `2020Q1` = `2020M01` + `2020M02` + `2020M03`, 
         `2020Q2` = `2020M04` + `2020M05` + `2020M06`, 
         `2020Q3` = `2020M07` + `2020M08` + `2020M09`,
         `2020Q4` = (`2020M10` + `2020M11`) * 1.5, 
         variable = case_when(variable == 'LC' ~ 'Sales', 
                              variable == 'UN' ~ 'Units', 
                              variable == 'CU' ~ 'DosageUnits')) %>% 
  select(Pack_Id, Corp_ID, MNF_ID, NFC1_Code, NFC12_Code, NFC123_Code, NFC2_Code, 
         NFC23_Code, Prd_desc, Pck_Desc, `MKT-TYPE_Desc`, GEN_PRD_Desc, 
         Molecule_Desc, ATC1_Code, ATC1_Desc, ATC2_Code, ATC2_Desc, ATC3_Code, 
         ATC3_Desc, ATC4_Code, ATC4_Desc, Mnf_Desc, MNF_TYPE, MnfType_Desc, 
         Corp_Desc, variable, ends_with(c('Q1', 'Q2', 'Q3', 'Q4'))) %>% 
  pivot_longer(cols = ends_with(c('Q1', 'Q2', 'Q3', 'Q4')), 
               names_to = 'Date', 
               values_to = 'value') %>% 
  pivot_wider(names_from = variable, 
              values_from = value)

## market
market.sanofi.lantus <- delivery.sanofi.lantus %>% 
  distinct(Market, PRODUCT.DESC)

market.sanofi.plavix <- delivery.sanofi.plavix %>% 
  distinct(Market, PRODUCT.DESC)

## Sanofi
chpa.sanofi.lantus <- chpa.fmt %>% 
  inner_join(market.sanofi.lantus, by = c('Prd_desc' = 'PRODUCT.DESC')) %>% 
  filter(Units > 0, Sales > 0, 
         stri_sub(Date, 1, 4) %in% c('2018', '2019', '2020')) %>% 
  select(Pack_Id, Date, ATC3 = ATC3_Code, Market, Molecule_Desc, 
         PRODUCT.DESC = Prd_desc, PACK.DESC = Pck_Desc, 
         CORPORATE.DESC = Corp_Desc, Units, Sales, DosageUnits)

chpa.sanofi.plavix <- chpa.fmt %>% 
  inner_join(market.sanofi.plavix, by = c('Prd_desc' = 'PRODUCT.DESC')) %>% 
  filter(Units > 0, Sales > 0, 
         stri_sub(Date, 1, 4) %in% c('2018', '2019', '2020')) %>% 
  select(Pack_Id, Date, ATC3 = ATC3_Code, Market, Molecule_Desc, 
         PRODUCT.DESC = Prd_desc, PACK.DESC = Pck_Desc, 
         CORPORATE.DESC = Corp_Desc, Units, Sales, DosageUnits)

write.xlsx(chpa.sanofi.lantus, '05_Internal_Review/Sanofi_CHC_Lantus_CHPA_2018Q1_2020Q4.xlsx')
write.xlsx(chpa.sanofi.plavix, '05_Internal_Review/Sanofi_CHC_Plavix_CHPA_2018Q1_2020Q4.xlsx')




