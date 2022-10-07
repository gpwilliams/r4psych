# Slack Question: Recreate my output from scratch.
# Note: use the Colour Brewer page to define your colours:
#   http://colorbrewer2.org/#type=sequential&scheme=YlOrRd&n=3

# linear fit from the mpg data set.
library(ggplot2)
data(mtcars)

mtcars_plot <- ggplot(data = mtcars, mapping = aes(x = wt, y = mpg)) +
  geom_point(size = 3, shape = 18, colour = "#feb24c") +
  geom_smooth(method = "lm", colour = "#f03b20") +
  labs(title = "A Linear Fit of Weight by Miles per Gallon from the mtcars Data Set", 
       x = "Weight", 
       y = "Miles per Gallon") +
  theme_bw() +
  theme(panel.grid.minor = element_blank())

ggsave("homework_answer.png", mtcars_plot)
