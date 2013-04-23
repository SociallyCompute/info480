mydata <-read.csv("http://ds101.seangoggins.net/Example-ND.csv", sep=",")
attach(mydata)

#Plots the data
plot(Year, EMD)

# Apply loess smoothing using the default span value of 0.8.  You can change the curve by changing the span value.
y.loess <- loess(y ~ x, span=0.8, data.frame(x=Year, y=EMD))

# Compute loess smoothed values for all points along the curve
y.predict <- predict(y.loess, data.frame(x=Year))

# Plots the curve.
lines(Year,y.predict)

#Add title
title(main="Simple Code Example")