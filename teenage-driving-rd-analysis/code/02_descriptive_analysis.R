# Purpose:
# Descriptive analysis of mortality around the minimum legal driving age
## Q1 – Mean mortality 1–24 months above vs. below Minimum Legal Driving Age (MLDA) -----------------------------------------------------------------------------------------------
q1_sample <- mort %>%
  filter(agemo_mda >= -24, # 2 years below MLDA
         agemo_mda <= 24,  # 2 years above MLDA
         agemo_mda != 0) %>%  #exclude 0 b/c that month is only partially treated
  mutate(
    above_mlda = agemo_mda > 0   # TRUE= 1–24 months above MLDA, which is treatment indicator (eligible to drive), 
  )

q1_summary <- q1_sample %>%
  group_by(above_mlda) %>%  
  summarize(
    mean_cod_any_rate = mean(cod_any_rate),
    .groups = "drop"
  )

q1_summary

#Difference in means (above − below) for any-cause mortality
q1_diff_any <- q1_summary$mean_cod_any_rate[q1_summary$above_mlda == TRUE] -
               q1_summary$mean_cod_any_rate[q1_summary$above_mlda == FALSE]

q1_diff_any


## Q2 – Scatter plot within 2 years of MLDA---------------------------------------------------------------------------------------------------------------------
q2_sample <- mort %>%
  filter(agemo_mda >= -24,
         agemo_mda <= 24)

# Scatter plot:
#create vertical line at eligibility cut off, when agemo_mda = 0
#   • black squares = any-cause mortality
#   • blue circles  = motor vehicle mortality

ggplot(q2_sample, aes(x = agemo_mda)) +
  geom_point(aes(y = cod_any_rate),
             shape = 15,        #square
             color = "black") +
  geom_point(aes(y = cod_mva_rate),
             shape = 16,      #circle
             color = "blue") +
  geom_vline(xintercept = 0, 
             color = "firebrick4",
             linewidth = 1,  
             linetype = "dashed") +
  theme_bw() +
  labs(
    x = "Months from minimum legal driving age",
    y = "Deaths per 100,000 person-years"
  )

