###############################################################################
# Simulate Data
#
# Generates data sets for analysis with ANOVA and regression
#  
###############################################################################

# load library; download devtools and funfact if not already installed
# library("devtools")
# install_github("dalejbarr/funfact")
library(funfact)
library(tidyverse)

# within-subjects design
########################

# specify design
factorial_design <- list(ivs = c(A = 2, B = 2), n_item = 40)

# specify parameters
beta <- list("(Intercept)" = c(240, 250), 
             "AA2" = c(5, 8),
             "BB2" = c(4, 6),
             "AA2:BB2" = c(10, 12)
             )
theta <- c(rep(220, 4))
sigma <- c(rep(320, 4))

# specify poplation parameters
popdata <- gen_pop(factorial_design, 
                   n_subj = 60, 
                   fixed_ranges = beta,
                   var_range = theta, 
                   err_range = sigma
)

# simulate data
set.seed(1000)
factorial_data <- sim_norm(factorial_design, n_subj = 60, popdata)

# check results
factorial_data %>% group_by(A, B) %>% summarise(m = mean(Y), sd = sd(Y))

# transform to tibble
factorial_data <- factorial_data %>%
  as.tibble() %>%
  mutate(A = factor(A),
         B = factor(B)
         )

# fit anova
contrasts(factorial_data$A) <- contr.sum
contrasts(factorial_data$B) <- contr.sum

Anova(aov(Y ~ A * B, factorial_data), type = "III")

# save data
write.csv(factorial_data, "../inputs/factorial_data.csv")
write.csv(factorial_data, "../../09_mixed_effects_models/inputs/factorial_data.csv")