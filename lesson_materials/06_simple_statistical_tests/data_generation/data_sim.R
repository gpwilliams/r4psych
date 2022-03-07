###############################################################################
# Simulate Data
#
# Generates data sets for analysis with t-tests, ANOVA, and correlation
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
wsubj_design <- list(
  ivs = c(A = 2),
  n_item = 40
)

# specify parameters
beta <- list(
  "(Intercept)" = c(300, 350),
  "AA2" = c(100, 120)
)

theta <- c(25, 50)
sigma <- c(25, 30)

# specify poplation parameters
popdata <- gen_pop(wsubj_design,
  n_subj = 60,
  fixed_ranges = beta,
  var_range = theta,
  err_range = sigma
)

# simulate data
set.seed(1000)
wsubj_data <- sim_norm(wsubj_design, n_subj = 60, popdata)

# check results
wsubj_data %>% group_by(A) %>% summarise(m = mean(Y), sd = sd(Y))

# between-subjects design
#########################

# specify design
bsubj_design <- list(
  ivs = c(A = 2),
  n_item = 40,
  between_subj = "A"
)

# simulate data
set.seed(1000)
bsubj_data <- sim_norm(bsubj_design, n_subj = 60, popdata)

# check data
bsubj_data %>% group_by(A) %>% summarise(m = mean(Y), sd = sd(Y))

# correlation design
####################

corr_data <- tibble(
  subject = seq(1:60),
  sex = c(rep("male", 30), rep("female", 30)),
  weight = c(
    rnorm(n = 30, mean = 84, sd = 7.5),
    rnorm(n = 30, mean = 69, sd = 7.5)
    ),
  height = c(weight + rnorm(n = 60, mean = 90, sd = 2))
)

# check data
corr_data %>%
  group_by(sex) %>%
  summarise(
    m_weight = mean(weight),
    m_weight = mean(height),
    sd = sd(weight),
    sd = sd(height)
  )

# binomial between subjects
###########################

prob <- rep(c(0.45, 0.5), 50)
cond <- rep(c("control", "intervention"), 50)
subject <- seq(1:100)

set.seed(1000)
binom_between_data <- tibble(
  subject = subject,
  cond = cond,
  outcome = rbinom(n = 100, size = 1, prob = prob)
)

# binomial within subjects
###########################

subject <- seq(1:100)
prob <- 0.3
n <- 100

set.seed(1000)
binom_within_data <- tibble(
  subject = subject,
  pre_test = rbinom(n = n, size = 1, prob = prob),
  post_test = rbinom(n = n, size = 1, prob = prob)
)

# make all successes in post if success in pre
binom_within_data <- binom_within_data %>%
  mutate(
    post_test =
      case_when(
        pre_test == 1 ~ 1,
        TRUE ~ as.double(post_test)
      ),
    post_test = as.integer(post_test)
  )

# save all data
###############

save_list <- list(
  bsubj_data = bsubj_data,
  wsubj_data = wsubj_data,
  corr_data = corr_data,
  binom_between_data = binom_between_data,
  binom_within_data = binom_within_data
)

mapply(write.csv,
  save_list,
  file = paste0("../inputs/", names(save_list), ".csv"),
  row.names = F
)
