###############################################################################
# Make Data for LMEs
#
# Makes new participants for the sleepstudy data set
#   This is very simple, in that we just make 2 new groups and
#     increase the reaction time numbers by adding a constant with the
#     rnorm() function for both groups. 
#   For group 3, we also add increasing values as Days increases
#
###############################################################################

# use install.packages("lme4") if you don't already have this package installed
library(lme4)
library(tidyverse)

# make Subject numeric for increasing values for other 2 groups
sleepstudy$Subject <- as.numeric(sleepstudy$Subject)

# make group 2: rnorm() for increased intercept over group 1
sleep_group2 <- sleepstudy %>% 
  mutate(Subject = Subject + 18,
         Reaction = Reaction + rnorm(n = 180, mean = 100, sd = 10),
         Group = "group_2"
  )

# make group 2: rnorm() for increased intercept over group 1
#  also increments value as Days increases for increased slope over group 1
sleep_group3 <- sleepstudy %>% 
  mutate(Subject = Subject + (18 * 2),
         Reaction = Reaction + 
           rnorm(n = 180, mean = 10, sd = 10) +
           Reaction * (1 + Days / 80),
         Group = "group_3"
  )

# bind it all together as a tibble
sleep_toy <- bind_rows(sleepstudy %>% 
                         mutate(Group = "group_1"),
                       sleep_group2,
                       sleep_group3
                       ) %>% 
  as.tibble()

# save data
write.csv(sleep_toy, row.names = F, "../inputs/sleep_study_with_sim_groups.csv")