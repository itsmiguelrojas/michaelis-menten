# Function for plotting enzyme rate
michaelis.eq <- function(substrate, Vmax, Km, inh.factor = NULL, linear = FALSE){
  substrate <- substrate[order(substrate)]
  
  x <- 1/substrate
  m <- Km/Vmax
  b <- 1/Vmax
  if(linear == TRUE){
    
    if(is.null(inh.factor) == TRUE){
      y <- m*x + b
    } else {
      y <- inh.factor*m*x + b
    }
    
  } else {
    
    if(is.null(inh.factor) == TRUE){
      y <- Vmax*substrate/(Km + substrate)
    } else {
      y <- Vmax*substrate/(inh.factor*Km + substrate)
    }
    
  }
  return(y)
}

# Predict Vmax and Km. Also predict KI, inhibition factor and
# type of inhibition if given rate in presence of inhibitor and
# inhibitor concentration
michaelisPredict <- function(substrate, rate, rate.inh = NULL, inh.conc = NULL){
  x <- substrate^-1
  y <- rate^-1
  
  if(is.null(rate.inh) == TRUE && is.null(inh.conc) == TRUE){
    
    lb.model <- lm(y ~ x)
    
    coeff <- lb.model$coefficients
    coeff[1] <- coeff[1]^-1
    coeff[2] <- coeff[1]*coeff[2]
    
    names(coeff) <- c('Vmax', 'Km')
    
    enzyme.list <- vector('list', 2)
    names(enzyme.list) <- c('Name', 'Parameters')
    enzyme.list[[1]] <- 'Michaelis-Menten Simple Steady-State Kinetics'
    enzyme.list[[2]] <- coeff
    
  } else {
    
    z <- rate.inh^-1
    
    lb.model.no.inh <- lm(y ~ x)
    lb.model.inh <- lm(z ~ x)
    
    coeff.no.inh <- lb.model.no.inh$coefficients
    coeff.inh <- lb.model.inh$coefficients
    
    Vmax.no.inh <- coeff.no.inh[1]^-1
    Vmax.inh <- coeff.inh[1]^-1
    
    K.no.inh <- coeff.no.inh[2]*Vmax.no.inh
    K.inh <- coeff.inh[2]*Vmax.inh
    
    inh.factor <- K.inh/K.no.inh
    
    Vmax <- c(Vmax.no.inh, Vmax.inh)
    Vmax.max <- max(Vmax)
    Vmax.min <- min(Vmax)
    Vmax.rate <- Vmax.min/Vmax.max
    
    if(Vmax.rate <= 1 && Vmax.rate >= 0.68){
      KI <- inh.conc/(inh.factor-1)
      Km <- K.no.inh
      Vmax <- mean(Vmax^-1)
      Vmax <- Vmax^-1
      
      enzyme.list <- vector('list', 3)
      names(enzyme.list) <- c('Name', 'Type of inhibition', 'Parameters')
      enzyme.list[[1]] <- 'Michaelis-Menten Simple Steady-State Kinetics With Inhibition'
      enzyme.list[[2]] <- 'Competitive'
      enzyme.list[[3]] <- c(Vmax, Km, KI, inh.factor)
      names(enzyme.list[[3]]) <- c('Vmax', 'Km', 'KI', 'Inhibition factor')
    }
    
    if(inh.factor^-1 <= 1 && inh.factor^-1 >= 0.68){
      KI <- inh.conc/(inh.factor-1)
      Km <- K.no.inh
      
      enzyme.list <- vector('list', 3)
      names(enzyme.list) <- c('Name', 'Type of inhibition', 'Parameters')
      enzyme.list[[1]] <- 'Michaelis-Menten Simple Steady-State Kinetics With Inhibition'
      enzyme.list[[2]] <- 'Non-competitive'
      enzyme.list[[3]] <- c(Vmax.no.inh, Vmax.inh, Km, KI, inh.factor)
      names(enzyme.list[[3]]) <- c('Vmax (no inhibition)', 'Vmax (inhibition)', 'Km', 'KI', 'Inhibition factor')
    }
    
  }
  
  return(enzyme.list)
}