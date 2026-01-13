## Q6: Participants vs non-participants – first-year outcomes

# Filter out participants in the treatment group
claims_treatment <- claims %>% filter(treat == 1)

# Df for Results
participant_results <- data.frame(
  Variable = character(),
  No_Controls = character(),
  With_Controls = character(),
  stringsAsFactors = FALSE
)

#Run Regressions 
for (i in 1:length(outcome_vars_post)) {
  var <- outcome_vars_post[i]
  label <- outcome_labels[i]
  
#Model 1: No controls
formula1 <- as.formula(paste(var, "~ completed_screening_nomiss_2016"))
  model1 <- lm(formula1, data = claims_treatment)
  coef1 <- coef(model1)[2]
  se1 <- summary(model1)$coefficients[2, 2]
  result1 <- sprintf("%.2f (%.2f)", coef1, se1)
  
#Model 2: WITH controls
formula2 <- as.formula(paste(var, "~ completed_screening_nomiss_2016 + male + white + age37_49 + age50"))
  model2 <- lm(formula2, data = claims_treatment)
  coef2 <- coef(model2)[2]
  se2 <- summary(model2)$coefficients[2, 2]
  result2 <- sprintf("%.2f (%.2f)", coef2, se2)

participant_results <- rbind(participant_results,
                               data.frame(Variable = label,
                                          No_Controls = result1,
                                          With_Controls = result2))
}

print(participant_results, row.names = FALSE)


## Summary Statistics 

#Participation Rate 
participation_rate <- mean(claims$completed_screening_nomiss_2016[claims$treat == 1], na.rm = TRUE) * 100
cat(sprintf("Participation rate among treatment group: %.1f%%\n", participation_rate))

#Average Spending Levels 
cat(sprintf("\nAverage pre-intervention spending: $%.2f\n", mean(claims$spend_0715_0716, na.rm = TRUE)))
cat(sprintf("Average post-intervention spending: $%.2f\n", mean(claims$spend_0816_0717, na.rm = TRUE)))
