# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  Sanofi CHC 2020Q4
# Purpose:      Check data
# programmer:   Zhe Liu
# Date:         2021-02-18
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


##---- Check SOP -----
# CHPA
chpa.fmt <- chpa.2020q4 %>% 
  pivot_longer(cols = starts_with(c('20')), 
               names_to = 'variable', 
               values_to = 'value') %>% 
  separate(variable, c('Date', 'measure'), sep = '_') %>% 
  pivot_wider(names_from = measure, 
              values_from = value)

## market
market.sanofi.lantus <- delivery.sanofi.lantus %>% 
  distinct(Market, PRODUCT.DESC)

market.sanofi.plavix <- delivery.sanofi.plavix %>% 
  distinct(Market, PRODUCT.DESC)

## Sanofi
chpa.sanofi.lantus <- chpa.fmt %>% 
  inner_join(market.sanofi.lantus, by = c('Prd_desc' = 'PRODUCT.DESC')) %>% 
  filter(stri_sub(Date, 1, 4) %in% c('2018', '2019', '2020'))

chpa.sanofi.plavix <- chpa.fmt %>% 
  inner_join(market.sanofi.plavix, by = c('Prd_desc' = 'PRODUCT.DESC')) %>% 
  filter(stri_sub(Date, 1, 4) %in% c('2018', '2019', '2020'))

write.xlsx(chpa.sanofi.lantus, '05_Internal_Review/Sanofi_CHC_Lantus_CHPA_2018Q1_2020Q4.xlsx')
write.xlsx(chpa.sanofi.plavix, '05_Internal_Review/Sanofi_CHC_Plavix_CHPA_2018Q1_2020Q4.xlsx')




