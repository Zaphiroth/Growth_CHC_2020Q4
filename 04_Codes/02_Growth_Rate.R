# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  Sanofi CHC 2020Q4
# Purpose:      Growth
# programmer:   Zhe Liu
# Date:         2021-02-08
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


##---- National growth ----
## Bluebook
national.growth.bb <- raw.bb %>% 
  mutate(Year = as.character(Year)) %>% 
  bind_rows(raw.gz.20q3, raw.gz.20q4) %>% 
  filter(Quarter %in% c('2020Q3', '2020Q4'), !is.na(packcode)) %>% 
  mutate(packcode = stri_pad_left(packcode, 7, 0)) %>% 
  group_by(Quarter, packcode) %>% 
  summarise(Value = sum(Value, na.rm = TRUE), 
            Volume = sum(Volume, na.rm = TRUE), 
            Dosage_Unit = sum(Dosage_Unit, na.rm = TRUE)) %>% 
  ungroup() %>% 
  pivot_wider(id_cols = packcode, 
              names_from = Quarter, 
              values_from = c(Value, Volume, Dosage_Unit), 
              values_fill = 0) %>% 
  mutate(growth_value = `Value_2020Q4` / `Value_2020Q3`, 
         growth_volume = `Volume_2020Q4` / `Volume_2020Q3`, 
         growth_dosage = `Dosage_Unit_2020Q4` / `Dosage_Unit_2020Q3`, 
         growth_dosage = if_else(is.na(growth_dosage) | is.infinite(growth_dosage) | growth_dosage == 0, 
                                 growth_volume, growth_dosage)) %>% 
  filter(!is.na(growth_value), !is.infinite(growth_value), growth_value != 0) %>% 
  select(packcode, growth_value, growth_volume, growth_dosage)

national.growth.chpa <- chpa.2020q4 %>% 
  mutate(growth_rmb = `2020Q4_RENMINBI` / `2020Q3_RENMINBI`, 
         growth_unit = `2020Q4_UNIT` / `2020Q3_UNIT`, 
         growth_su = `2020Q4_SU` / `2020Q3_SU`) %>% 
  select(Pack_ID, growth_rmb, growth_unit, growth_su) %>% 
  filter(!is.na(growth_rmb), !is.infinite(growth_rmb), growth_rmb != 0)

national.growth <- national.growth.bb %>% 
  full_join(national.growth.chpa, by = c('packcode' = 'Pack_ID')) %>% 
  mutate(growth_value = if_else(is.na(growth_value), growth_rmb, growth_value), 
         growth_volume = if_else(is.na(growth_volume), growth_unit, growth_volume), 
         growth_dosage = if_else(is.na(growth_dosage), growth_su, growth_dosage)) %>% 
  mutate(growth_value = case_when(packcode %in% c('0731302', '1394502', '5025402', 
                                                  '5310008', '4123206') ~ growth_rmb, 
                                  packcode == '0807904' ~ growth_value/6, 
                                  TRUE ~ growth_value), 
         growth_volume = case_when(packcode %in% c('0731302', '1394502', '5025402', 
                                                   '5310008', '4123206') ~ growth_unit, 
                                   packcode == '0807904' ~ growth_volume/6, 
                                   packcode == '7125704' ~ growth_value, 
                                   TRUE ~ growth_volume), 
         growth_dosage = case_when(packcode == '6945702' ~ growth_volume, 
                                   packcode == '7125704' ~ growth_value, 
                                   packcode %in% c('0731302', '1394502', '5025402', 
                                                   '5310008', '4123206') ~ growth_su, 
                                   packcode == '0807904' ~ growth_dosage/6, 
                                   TRUE ~ growth_dosage)) %>% 
  select(packcode, growth_value, growth_volume, growth_dosage)

write.xlsx(national.growth, '03_Outputs/National_Growth.xlsx')
