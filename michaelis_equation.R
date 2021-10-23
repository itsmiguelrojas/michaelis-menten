# Make function for enzyme kinetics
michaelis.eq <- function(data, Vmax, Km, linear = FALSE){
  x <- 1/data
  m <- Km/Vmax
  b <- 1/Vmax
  if(linear == TRUE){
    y <- m*x + b
  } else {
    y <- Vmax*data/(Km + data)
  }
  return(y)
}

# Load libraries
library(tidyverse)
library(hrbrthemes)
library(ggpubr)

# Establish values for Vmax and Km
Vmax <- 1.23
Km <- 2.57

# Values for sustrate
s.concentration <- seq(0.1,30,0.1)

# Values for velocity (Michaelis-Menten and Lineweaver-Burk)
velocity <- michaelis.eq(s.concentration, Vmax, Km)
inv.velocity <- michaelis.eq(s.concentration, Vmax, Km, T)

# Data frame
enzyme.act <- data.frame(
  s.concentration,
  velocity,
  inv.s.concentration = s.concentration^-1,
  inv.velocity
)

# Remove numeric variables
rm(s.concentration, velocity, inv.velocity)

# Michaelis-Menten plot
mm.plot <- enzyme.act %>%
  ggplot(aes(x = s.concentration, y = velocity)) +
  geom_line(color = 'salmon', lwd = 1.2) +
  labs(
    x = '[S]',
    y = expression("V"["0"]),
    title = 'Michaelis-Menten curve'
  ) +
  theme_ipsum() +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

# Lineweaver-Burk plot
lb.plot <- enzyme.act %>%
  ggplot(aes(x = inv.s.concentration, y = inv.velocity)) +
  geom_line(color = 'blue', lwd = 1.2) +
  labs(
    x = expression("1/[S]"),
    y = expression("1/V"["0"]),
    title = 'Lineweaver-Burk linearization'
  ) +
  theme_ipsum() +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

# Arrange plots
ggarrange(mm.plot, lb.plot, ncol = 2)