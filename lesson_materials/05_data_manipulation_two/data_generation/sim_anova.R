# Simulate data for 2 x 2 ANOVA
# code from: https://stats.stackexchange.com/questions/115748/simulate-data-for-2-x-2-anova-with-interaction

library(dplyr)
library(magrittr)

# Make 2 x 2 anova type data
############################

# How many subjects?
n_subj <- 100

# Set coefficients
alpha = 400 # intercept
beta1 = -40 # caffeine
beta2 = -1 # response
beta3 = -15 # interaction

# Generate condition factors and levels
# Condition A: 50 * 0, 50 * 1
A = c(rep(0, n_subj/2), rep(1, n_subj/2))

# Condition B: 25 * 0, 25 * 1, 25 * 0, 25 * 1
B = rep(c(rep(0, n_subj/4), rep(1, n_subj/4)), 2)

# Error term: noise with SD = 3
set.seed(1000)
err = rnorm(n_subj, 0, sd = 3)

# Generate response data using regression
set.seed(1000)
y = alpha + beta1 * A + beta2 * B + beta3 * A * B + err

# join together with demographic samples
data <- tibble(
  subject = seq(1:n_subj),
  age = sample(18:68, size = n_subj, replace = T),
  caffeine = factor(A, levels = c(0, 1), labels = c("no", "yes")),
  response = factor(B, levels = c(0, 1), labels = c("non-dominant", "dominant")),
  DV = y
)

# Means: check data makes sense
data %>% group_by(caffeine, response) %>% summarise(m = mean(DV))

# Linear model: Does the data make sense?
model = lm(y ~ caffeine*response, data = data)
summary(model)

# save data as RDs
save(data, file = "../inputs/sim_data.RData")
