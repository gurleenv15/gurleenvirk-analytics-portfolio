# Purpose:
# Estimate parametric donut RD with linear trends on either side of the cutoff
## Q4 – Parametric “donut” RD with linear trends on each side of the cutoff (separate slopes) ---------------------------------------------------------------------------------------------------------------------
param_results <- tibble()

for (B in bandwidths) {
  
#Same donut RD sample restriction
  sample_B <- mort %>%
    filter(abs(agemo_mda) <= B,
           agemo_mda != 0) %>%
    mutate(
      treat = agemo_mda > 0,
      treat_x_agemo = treat * agemo_mda #this is the interaction term that allows different linear slopes
    )

#Parametric RD: allow linear trends on each side of cutoff
  
  #Any-cause mortality
  model_any_par <- lm(
  cod_any_rate ~ treat + agemo_mda + treat_x_agemo,
  data = sample_B
  )
  tidy_any_par  <- tidy(model_any_par)
  rd_any_par    <- tidy_any_par$estimate[tidy_any_par$term == "treatTRUE"]
  se_any_par    <- tidy_any_par$std.error[tidy_any_par$term == "treatTRUE"]
  
  #Motor vehicle accident mortality
  model_mva_par <- lm(
    cod_mva_rate ~ treat + agemo_mda + treat_x_agemo,
    data = sample_B
    )
  tidy_mva_par  <- tidy(model_mva_par)
  rd_mva_par    <- tidy_mva_par$estimate[tidy_mva_par$term == "treatTRUE"]
  se_mva_par    <-tidy_mva_par$std.error[tidy_mva_par$term == "treatTRUE"]
  
#Store parametric RD estimates and SEs for each bandwidth 
  param_results <- bind_rows(
    param_results,
    tibble(
      bandwidth_months = B,
      rd_any_param  = rd_any_par,
      se_any_param  = se_any_par,
      rd_mva_param  = rd_mva_par,
      se_mva_param  = se_mva_par
    )
  )
}

param_results

