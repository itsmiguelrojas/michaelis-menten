# Load functions
source('michaelis_functions.R')

# Load libraries
library(readxl)
library(tidyverse)
library(hrbrthemes)
library(ggpubr)

# Load data
enzyme.act <- read_xlsx('enzyme_activity.xlsx', sheet = 'Example 1')
enzyme.act.nc <- read_xlsx('enzyme_activity.xlsx', sheet = 'Non-competitive')
enzyme.act.c <- read_xlsx('enzyme_activity.xlsx', sheet = 'Competitive')

# Replace column names
colnames(enzyme.act) <- c('s.conc', 'rate')
colnames(enzyme.act.nc) <- c('s.conc', 'rate', 'rate.inh')
colnames(enzyme.act.c) <- c('s.conc', 'rate', 'rate.inh')

#############
# Example 1 #
#############

# Predict parameters
enzyme.constants <- michaelisPredict(enzyme.act$s.conc, enzyme.act$rate)
enzyme.constants

# Get rate values from predicition and real
x <- seq(0.1, 20, 0.1)
y <- michaelis.eq(x, enzyme.constants$Parameters[1], enzyme.constants$Parameters[2])
y2 <- michaelis.eq(x, Vmax = 6.84, Km = 5.22)
y.linear <- michaelis.eq(x, enzyme.constants$Parameters[1], enzyme.constants$Parameters[2], linear = TRUE)
y2.linear <- michaelis.eq(x, Vmax = 6.84, Km = 5.22, linear = TRUE)

enzyme.pred.ideal <- data.frame(
  s.conc = x,
  inv.s.conc = x^-1,
  rate.pred = y,
  inv.rate.pred = y.linear,
  rate.ideal = y2,
  inv.rate.ideal = y2.linear
)

# Remove variables
rm(y, y2, y.linear, y2.linear)

# Michaelis-Menten plot
mm.plot.example1 <- enzyme.pred.ideal %>%
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
lb.plot.example1 <- enzyme.pred.ideal %>%
  ggplot(aes(x = inv.s.conc)) +
  geom_line(aes(y = inv.rate.pred, color = 'Prediction'), lwd = 1.2) +
  geom_line(aes(y = inv.rate.ideal, color = 'Real'), lwd = 1.2) +
  labs(
    x = expression("1/[S] (μM"^-1*")"),
    y = expression("1/V"["0"]*" (min/mol"^-10*")"),
    title = 'Lineweaver-Burk linearization',
    colour = 'Rate'
  ) +
  theme_ipsum() +
  scale_colour_manual(values = c('red', 'navyblue')) +
  theme(legend.position = 'bottom', plot.title = element_text(hjust = 0.5))

# Graph both scatterplots
ggarrange(mm.plot.example1, lb.plot.example1, ncol = 2, common.legend = T)

###################
# Non-competitive #
###################

# Predict parameters
nc.inhibition <- michaelisPredict(
  enzyme.act.nc$s.conc,
  enzyme.act.nc$rate,
  enzyme.act.nc$rate.inh,
  40
)

nc.inhibition

# Get rate values for no inhibition and inhibition
rate <- michaelis.eq(x, nc.inhibition$Parameters[1], nc.inhibition$Parameters[3])
rate.inh <- michaelis.eq(x, Vmax = nc.inhibition$Parameters[2], Km = nc.inhibition$Parameters[3], inh.factor = nc.inhibition$Parameters[5])
inv.rate <- michaelis.eq(x, nc.inhibition$Parameters[1], nc.inhibition$Parameters[3], linear = TRUE)
inv.rate.inh <- michaelis.eq(x, Vmax = nc.inhibition$Parameters[2], Km = nc.inhibition$Parameters[3], inh.factor = nc.inhibition$Parameters[5], linear = TRUE)

enzyme.pred.nc <- data.frame(
  s.conc = x,
  inv.s.conc = x^-1,
  rate,
  rate.inh,
  inv.rate,
  inv.rate.inh
)

# Remove variables
rm(rate, rate.inh, inv.rate, inv.rate.inh)

# Michaelis-Menten plot
mm.plot.nc <- enzyme.pred.nc %>%
  ggplot(aes(x = s.conc)) +
  geom_line(aes(y = rate, color = 'No inhibition'), lwd = 1.2) +
  geom_line(aes(y = rate.inh, color = 'Inhibition'), lwd = 1.2) +
  labs(
    x = '[S] (mM)',
    y = expression("V"["0"]*" (mg/min)"),
    title = 'Michaelis-Menten curve',
    subtitle = 'Non-competitive inhibition',
    colour = 'Type'
  ) +
  theme_ipsum() +
  scale_colour_manual(values = c('navyblue', 'red')) +
  theme(legend.position = 'bottom', plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))

# Lineweaver-Burk plot
lb.plot.nc <- enzyme.pred.nc %>%
  ggplot(aes(x = inv.s.conc)) +
  geom_line(aes(y = inv.rate, color = 'No inhibition'), lwd = 1.2) +
  geom_line(aes(y = inv.rate.inh, color = 'Inhibition'), lwd = 1.2) +
  xlim(0,0.7) +
  ylim(0,14) +
  labs(
    x = expression("1/[S] (mM"^-1*")"),
    y = expression("1/V"["0"]*" (min/mg)"),
    title = 'Lineweaver-Burk linearization',
    subtitle = 'Non-competitive inhibition',
    colour = 'Type'
  ) +
  theme_ipsum() +
  scale_colour_manual(values = c('navyblue', 'red')) +
  theme(legend.position = 'bottom', plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))

# Graph both scatterplots
ggarrange(mm.plot.nc, lb.plot.nc, ncol = 2)

###############
# Competitive #
###############

# Predict parameters
c.inhibition <- michaelisPredict(
  enzyme.act.c$s.conc,
  enzyme.act.c$rate,
  enzyme.act.c$rate.inh,
  6
)

c.inhibition

# Get rate values for no inhibition and inhibition
rate <- michaelis.eq(x, c.inhibition$Parameters[1], c.inhibition$Parameters[2])
rate.inh <- michaelis.eq(x, Vmax = c.inhibition$Parameters[1], Km = c.inhibition$Parameters[2], inh.factor = c.inhibition$Parameters[4])
inv.rate <- michaelis.eq(x, c.inhibition$Parameters[1], c.inhibition$Parameters[2], linear = TRUE)
inv.rate.inh <- michaelis.eq(x, Vmax = c.inhibition$Parameters[1], Km = c.inhibition$Parameters[2], inh.factor = c.inhibition$Parameters[4], linear = TRUE)

enzyme.pred.c <- data.frame(
  s.conc = x,
  inv.s.conc = x^-1,
  rate,
  rate.inh,
  inv.rate,
  inv.rate.inh
)

# Remove variables
rm(rate, rate.inh, inv.rate, inv.rate.inh)

# Michaelis-Menten plot
mm.plot.c <- enzyme.pred.c %>%
  ggplot(aes(x = s.conc)) +
  geom_line(aes(y = rate, color = 'No inhibition'), lwd = 1.2) +
  geom_line(aes(y = rate.inh, color = 'Inhibition'), lwd = 1.2) +
  labs(
    x = '[S] (mM)',
    y = expression("V"["0"]*" (g/h)"),
    title = 'Michaelis-Menten curve',
    subtitle = 'Competitive inhibition',
    colour = 'Type'
  ) +
  theme_ipsum() +
  scale_colour_manual(values = c('navyblue', 'red')) +
  theme(legend.position = 'bottom', plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))

# Lineweaver-Burk plot
lb.plot.c <- enzyme.pred.c %>%
  ggplot(aes(x = inv.s.conc)) +
  geom_line(aes(y = inv.rate, color = 'No inhibition'), lwd = 1.2) +
  geom_line(aes(y = inv.rate.inh, color = 'Inhibition'), lwd = 1.2) +
  xlim(0,0.6) +
  ylim(0,0.012) +
  labs(
    x = expression("1/[S] (mM"^-1*")"),
    y = expression("1/V"["0"]*" (h/g)"),
    title = 'Lineweaver-Burk linearization',
    subtitle = 'Competitive inhibition',
    colour = 'Type'
  ) +
  theme_ipsum() +
  scale_colour_manual(values = c('navyblue', 'red')) +
  theme(legend.position = 'bottom', plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))

# Graph both scatterplots
ggarrange(mm.plot.c, lb.plot.c, ncol = 2)