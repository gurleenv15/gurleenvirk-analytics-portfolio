# Purpose:
# Load mortality data and construct death rates per 100,000 person-years

library(tidyverse)
library(haven)
library(ggplot2)
library(broom)

mort <- read_dta("https://julianreif.com/driving/data/mortality/derived/all.dta")

mort <- mort %>%
  mutate(
    cod_any_rate = 100000 * cod_any / (pop / 12),
    cod_mva_rate = 100000 * cod_MVA / (pop / 12)
  ) 
