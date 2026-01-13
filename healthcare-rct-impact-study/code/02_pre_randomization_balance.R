#Count how many employees are in the treatment and control groups, table(claims$treat) returns counts for 0 and 1

treat_counts <- table(claims$treat)

cat("Number of employees in the CONTROL group (treat = 0):",
treat_counts["0"], "\n")
cat("Number of employees in the TREATMENT group (treat = 1):",
treat_counts["1"], "\n")

participation_count <- sum(claims$completed_screening_nomiss_2016 == 1 & claims$treat == 1, na.rm = TRUE)
cat("Participants in treatment group (completed year 1 screening):", participation_count, "\n")



## Q4: Pre-randomization balance for each outcome in the claims dataset,  as measured pre-randomization (i.e., prior to August 2016)

  # Pre-period outcomes (July 2015–July 2016)
outcome_vars_pre <- c(
  "spend_0715_0716",      # Total spending
  "spendOff_0715_0716",   # Office/ambulatory spending
  "spendRx_0715_0716",    # Prescription drug spending
  "spendHosp_0715_0716"   # Hospital spending
)

outcome_labels <- c(
  "Total Spending",
  "Office Visit Spending",
  "Prescription Drug Spending",
  "Hospital Spending"
)

balance_table <- data.frame(
  Variable = character(),
  Control_Mean = numeric(),
  Treatment_Mean = numeric(),
  Difference = numeric(),
  P_Value = numeric(),
  stringsAsFactors = FALSE
)

#Run Regression
for (i in 1:length(outcome_vars_pre)) {
  var <- outcome_vars_pre[i]
  label <- outcome_labels[i]

  formula <- as.formula(paste(var, "~ treat"))
  model <- lm(formula, data = claims)

control_mean <- coef(model)[1]
  treatment_coef <- coef(model)[2]
  treatment_mean <- control_mean + treatment_coef
  p_value <- summary(model)$coefficients[2, 4]

balance_table <- rbind(balance_table, 
                        data.frame(Variable = label,
                                   Control_Mean = round(control_mean, 2),
                                   Treatment_Mean = round(treatment_mean, 2),
                                   Difference = round(treatment_coef, 2),
                                   P_Value = round(p_value, 3)))

}

print(balance_table, row.names = FALSE)
