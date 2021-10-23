# Function for plotting enzyme rate
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

# Predict Vmax and Km values (requires [S] and V, not their inverse values)
michaelisPredict <- function(substrate, rate){
  x <- substrate^-1
  y <- rate^-1
  
  lb.model <- lm(y ~ x)
  coefficients <- lb.model$coefficients
  coefficients[1] <- coefficients[1]^-1
  coefficients[2] <- coefficients[1]*coefficients[2]
  names(coefficients) <- c('Vmax', 'Km')
  return(coefficients)
}