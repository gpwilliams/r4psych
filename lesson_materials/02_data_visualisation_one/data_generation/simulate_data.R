###############################################################################
# Simulate Data
#
# Generates a data.frame of n participants
#  randomly sampling between male and female genders
#  and from two response conditions
#
# Generates a dependent variable (reaction_time)
#  sampling from a mean and standard deviation for each group
#  and adding noise for each group
#  
###############################################################################

# set seed to ensure we all get the same data
set.seed(1000)

# how many samples (change to your liking)?
n <- 60

# set up data format
rt_data <- data.frame(particpant = seq(1: n),
                      gender = sample(c("male", "female"), n, replace = T),
                      response_condition = c(rep("match", n/2), 
                                        rep("mismatch", n/2)
                                       )
                      )

# create data for our dependent variable
rt_data$reaction_time <- ifelse(rt_data$response_condition == "match", 
                                rnorm(n, mean = 300, sd = 40) + # 
                                  runif(n, 0, 50),
                                rnorm(n, mean = 400, sd = 50) + 
                                  runif(n, 0, 60)
                                )

# save data as a .csv for both lessons
write.csv(rt_data, "../inputs/rt_data.csv", row.names = F)
write.csv(rt_data, "../../03_data_visualisation_two/inputs/rt_data.csv", 
          row.names = F
          )