# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  Sanofi CHC 2020Q4
# Purpose:      Result
# programmer:   Zhe Liu
# Date:         2021-02-08
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


##---- Sanofi ----
delivery.sanofi.lantus <- history.sanofi.lantus %>% 
  filter(YM == '2020Q3') %>% 
  left_join(national.growth, by = c('PACK' = 'packcode')) %>% 
  mutate(growth_value = if_else(is.na(growth_value), 1, growth_value), 
         growth_volume = if_else(is.na(growth_volume), 1, growth_volume), 
         growth_dosage = if_else(is.na(growth_dosage), 1, growth_dosage), 
         Unit = case_when(
           Measurement == 'Value(RMB)' ~ Unit * growth_value, 
           Measurement == 'Volume(Dosage unit)' ~ Unit * growth_dosage, 
           Measurement == 'T day' ~ Unit * growth_dosage, 
           TRUE ~ NaN
         )) %>% 
  mutate(YM = '2020Q4') %>% 
  select(-growth_value, -growth_volume, -growth_dosage) %>% 
  bind_rows(history.sanofi.lantus) %>% 
  mutate(Measurement = factor(Measurement, levels = c('Value(RMB)', 'Volume(Dosage unit)', 'T day'))) %>% 
  arrange(YM, Market, PACK, Measurement)

delivery.sanofi.plavix <- history.sanofi.plavix %>% 
  filter(YM == '2020Q3') %>% 
  left_join(national.growth, by = c('PACK' = 'packcode')) %>% 
  mutate(growth_value = if_else(is.na(growth_value), 1, growth_value), 
         growth_volume = if_else(is.na(growth_volume), 1, growth_volume), 
         growth_dosage = if_else(is.na(growth_dosage), 1, growth_dosage), 
         Unit = case_when(
           Measurement == 'Value(RMB)' ~ Unit * growth_value, 
           Measurement == 'Volume(Dosage unit)' ~ Unit * growth_dosage, 
           Measurement == 'T day' ~ Unit * growth_dosage, 
           TRUE ~ NaN
         )) %>% 
  mutate(YM = '2020Q4') %>% 
  select(-growth_value, -growth_volume, -growth_dosage) %>% 
  bind_rows(history.sanofi.plavix) %>% 
  mutate(Measurement = factor(Measurement, levels = c('Value(RMB)', 'Volume(Dosage unit)', 'T day'))) %>% 
  arrange(YM, Market, PACK, Measurement)

write.xlsx(delivery.sanofi.lantus, '03_Outputs/lantus_chc_2018Q1_2020Q4.xlsx')
write.xlsx(delivery.sanofi.plavix, '03_Outputs/plavix_chc_2018Q1_2020Q4.xlsx')


##---- Adjustment ----
sanofi.lantus.adj <- delivery.sanofi.lantus %>% 
  mutate(Unit = case_when(
    YM == '2020Q4' & PRODUCT.DESC == 'LANTUS             AVS' ~ Unit * 0.91, 
    YM == '2020Q4' & PRODUCT.DESC == 'USLIN 30R          ZUI' ~ Unit * 3, 
    YM == '2020Q4' & PRODUCT.DESC == 'NOVOMIX50 PENFILL  NKT' ~ Unit * 0.2, 
    YM == '2020Q4' & PRODUCT.DESC == 'GANSULIN R         TDB' ~ Unit * 0.5, 
    TRUE ~ Unit
  ))

sanofi.plavix.adj <- delivery.sanofi.plavix %>% 
  mutate(Unit = case_when(
    YM == '2020Q4' & PRODUCT.DESC == 'BAYASPIRIN         BAY' ~ Unit * 1.25, 
    TRUE ~ Unit
  ))

write.xlsx(sanofi.lantus.adj, '03_Outputs/lantus_chc_2018Q1_2020Q4.xlsx')
write.xlsx(sanofi.plavix.adj, '03_Outputs/plavix_chc_2018Q1_2020Q4.xlsx')


