# Purpose:
# Estimate non-parametric donut RD effects of driving eligibility on mortality

## Q3 – Non-parametric “donut” RD (difference in means) for four bandwidths, using linear regression
bandwidths <- c(48, 24, 12, 6)

nonparam_results <- tibble()

for (B in bandwidths) {
  
#Keep obs within bandwidth, drop partially treated month to create donut
  sample_B <- mort %>%
    filter(abs(agemo_mda) <= B,
           agemo_mda != 0) %>%
    mutate(
      treat = agemo_mda > 0     # TRUE(1) if above MLDA
    )

#Linear regression: difference in means (non-parametric RD)

  # Any-cause mortality
  model_any <- lm(cod_any_rate ~ treat, data = sample_B)
  tidy_any  <- tidy(model_any)
  rd_any    <- tidy_any$estimate[tidy_any$term == "treatTRUE"] #RD effect
  se_any    <- tidy_any$std.error[tidy_any$term == "treatTRUE"] #std error
  
  # Motor vehicle accident mortality
  model_mva <- lm(cod_mva_rate ~ treat, data = sample_B)
  tidy_mva  <- tidy(model_mva)
  rd_mva    <- tidy_mva$estimate[tidy_mva$term == "treatTRUE"]
  se_mva    <- tidy_mva$std.error[tidy_mva$term == "treatTRUE"]
  
  # Store RD estimates for each bandwidth in table 
  nonparam_results <- bind_rows(
    nonparam_results,
    tibble(
      bandwidth_months = B,
      rd_any_nonparam  = rd_any,
      se_any_nonparam  = se_any,
      rd_mva_nonparam  = rd_mva,
      se_mva_nonparam  = se_mva
    )
  )
}

nonparam_results
