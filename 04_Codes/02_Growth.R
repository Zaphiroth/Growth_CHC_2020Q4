# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  Growth CHC
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

national.growth.chpa <- raw.chpa %>% 
  filter(variable %in% c('LC', 'UN', 'CU')) %>% 
  mutate(`2020Q4` = (`2020M10` + `2020M11`) * 1.5, 
         `2020Q3` = `2020M07` + `2020M08` + `2020M09`, 
         growth = `2020Q4` / `2020Q3`, 
         variable = stri_paste('growth_', variable)) %>% 
  pivot_wider(id_cols = Pack_Id, 
              names_from = variable, 
              values_from = growth) %>% 
  filter(!is.na(growth_LC), !is.infinite(growth_LC), growth_LC != 0)

national.growth <- national.growth.bb %>% 
  full_join(national.growth.chpa, by = c('packcode' = 'Pack_Id')) %>% 
  mutate(growth_value = if_else(is.na(growth_value), growth_LC, growth_value), 
         growth_volume = if_else(is.na(growth_volume), growth_UN, growth_volume), 
         growth_dosage = if_else(is.na(growth_dosage), growth_CU, growth_dosage)) %>% 
  select(packcode, growth_value, growth_volume, growth_dosage)


