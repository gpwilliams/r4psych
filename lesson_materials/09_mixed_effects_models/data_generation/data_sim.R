###############################################################################
# Make Data for LMEs
#
# Makes new participants for the sleepstudy data set
#   Here, we use the simulate() function from lme4,
#     to create data for new particiopants. Note that we keep the original data
#     instead of simulating new data for all participants.
#   We then delete some values for a few participants to see
#     the advantages of LMMs for missing data
#
###############################################################################

# load library; install it if necessary using intall.packages("lme4")
library(lme4)
library(tidyverse)

# tidy up the sleepstudy data set
sleep_study <- sleepstudy %>%
  mutate(Subject = as.integer(Subject)) %>%
  as.tibble() %>%
  select(Subject, Days, Reaction)

# fit a model on the sleepstudy data set
sleepmod <- lmer(Reaction ~ Days + (Days | Subject), sleep_study)

# make new data structure based on sleepstudy
sleep_new <- sleep_study[1:30,] %>%
  mutate(Subject = rep(x = 19:21, each = 10), Reaction = NA)

# simulate data from model fit to new participants
sleep_new$Reaction <- simulate(sleepmod,
                            seed = 1e4,
                            newdata = sleep_new,
                            re.form = NA,
                            allow.new.levels = T)$sim_1

# bind old and new data together
sleep_study <- bind_rows(sleep_study, sleep_new) %>%
  mutate(Subject = factor(Subject))

# set some values for participant 19 and 20 to NA
sleep_study$Reaction[c(186:190, 193:200, 205:206)] <- NA

# save data
write.csv(sleep_study, row.names = F, "../inputs/sleep_study_with_sim.csv")
