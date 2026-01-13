## Q5: Treatment effects – first-year outcomes (claims)

outcome_vars_post <- c(
  "spend_0816_0717",    # Total medical spending
  "spendOff_0816_0717", # Office visit spending
  "spendRx_0816_0717",  # Prescription drug spending
  "spendHosp_0816_0717" # Hospital spending
)
outcome_labels <- c(
  "Total Spending",
  "Office Visit Spending",
  "Prescription Drug Spending",
  "Hospital Spending"
)

#Results DF 
itt_results <- data.frame(
  Variable      = character(),
  No_Controls   = character(),
  With_Controls = character(),
  stringsAsFactors = FALSE
)

#Run Regression
for (i in 1:length(outcome_vars_post)) {
  var   <- outcome_vars_post[i]
  label <- outcome_labels[i]
  
  # Model NO Controls 
  formula1 <- as.formula(paste(var, "~ treat"))
  model1   <- lm(formula1, data = claims)
  coef1    <- coef(model1)[2]
  se1      <- summary(model1)$coefficients[2, 2]
  result1  <- sprintf("%.2f (%.2f)", coef1, se1)
  
  # Model WITH Controls 
  formula2 <- as.formula(paste(var, "~ treat + male + white + age37_49 + age50"))
  model2   <- lm(formula2, data = claims)
  coef2    <- coef(model2)["treat"]
  se2      <- summary(model2)$coefficients["treat", 2]
  result2  <- sprintf("%.2f (%.2f)", coef2, se2)
  
  # Add this outcome's results as a new row
  itt_results <- rbind(
    itt_results,
    data.frame(
      Variable      = label,
      No_Controls   = result1,
      With_Controls = result2,
      stringsAsFactors = FALSE
    )
  )
}

print(itt_results)
