# Michaelis-Menten equation for reaction rate

Michaelis-Menten equation is a well-known model in biochemistry for enzyme kinetics. This takes the concentration of a certain substrate <img src="https://render.githubusercontent.com/render/math?math=[S]" /> and maximum rate <img src="https://render.githubusercontent.com/render/math?math=V_{max}" /> to calculate the reaction rate:

<img src="https://render.githubusercontent.com/render/math?math=v%20=%20\frac{V_{max}[S]}{K_M %2B [S]}" />

where <img src="https://render.githubusercontent.com/render/math?math=K_M" /> is the **Michaelis constant**.

I made this R function to calculate the reaction rate via **Michaelis-Menten** and also with the possibility to use **Lineweaver-Burk** linearization:

<img src="https://render.githubusercontent.com/render/math?math=\frac{1}{v}%20=%20\frac{K_M}{V_{max}}\frac{1}{[S]}%2B\frac{1}{V_{max}}" />

## Import

You can download `michaelis_equation.R` and delete the lines below and keep the `michaelis.eq()` function only. Then import to your project:

```r
source('michaelis_equation.R')
```

## How to use?

This function has **four arguments**:

- **data**: Substrate concentration
- **Vmax**: Maximum rate of the reaction
- **Km**: Michaelis constant
- **linear**: Lineweaver-Burk linearization. Calculate the inverse of the reaction rate. Defaults to `FALSE`

## Plot example

![](https://github.com/itsmiguelrojas/michaelis-menten/blob/main/enzyme_velocity.svg)
