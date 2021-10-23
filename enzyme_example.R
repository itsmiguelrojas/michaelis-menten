# Load functions
source('michaelis_functions.R')

# Load libraries
library(readxl)
library(tidyverse)
library(hrbrthemes)
library(ggpubr)

# Load data
enzyme.act <- read_xlsx('enzyme_activity.xlsx')

# Replace column names
colnames(enzyme.act) <- c('s.conc', 'rate')

# Predict Km and Vmax
enzyme.constants <- michaelisPredict(enzyme.act$s.conc, enzyme.act$rate)
enzyme.constants

# Plot Michaelis-Menten graph
x <- seq(0.1, 20, 0.1)
y <- michaelis.eq(x, enzyme.constants[1], enzyme.constants[2])
y2 <- michaelis.eq(x, Vmax = 6.84, Km = 5.22)

enzyme.pred.ideal <- data.frame(
  s.conc = x,
  rate.pred = y,
  rate.ideal = y2
)

rm(x, y, y2)

# Michaelis-Menter plot
mm.plot <- enzyme.pred.ideal %>%
  ggplot(aes(x = s.conc)) +
  geom_line(aes(y = rate.pred, color = 'Prediction'), lwd = 1.2) +
  geom_line(aes(y = rate.ideal, color = 'Real'), lwd = 1.2) +
  labs(
    x = '[S] (μM)',
    y = expression("V"["0"]*" (mol"^-10*"/min)"),
    title = 'Michaelis-Menten curve',
    colour = 'Rate'
  ) +
  theme_ipsum() +
  scale_colour_manual(values = c('red', 'navyblue')) +
  theme(legend.position = 'bottom', plot.title = element_text(hjust = 0.5))

# Lineweaver-Burk plot
lb.plot <- enzyme.pred.ideal %>%
  ggplot(aes(x = s.conc^-1)) +
  geom_line(aes(y = rate.pred^-1, color = 'Prediction'), lwd = 1.2) +
  geom_line(aes(y = rate.ideal^-1, color = 'Real'), lwd = 1.2) +
  labs(
    x = expression("1/[S] (μM"^-1*")"),
    y = expression("1/V"["0"]*" (min/mol"^-10*")"),
    title = 'Lineweaver-Burk linearization',
    colour = 'Rate'
  ) +
  theme_ipsum() +
  scale_colour_manual(values = c('red', 'navyblue')) +
  theme(legend.position = 'bottom', plot.title = element_text(hjust = 0.5))

ggarrange(mm.plot, lb.plot, ncol = 2, common.legend = T)