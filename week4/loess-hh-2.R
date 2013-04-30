mydata <-read.csv("http://ds101.seangoggins.net/Example-ND.csv", sep=",")
attach(mydata)
reg1 <- lm(EMD~Year)
par(cex=1)

#Plots the data but makes nondetects a different color and type based on column D_EMD being a 0 for ND and 1 for detect.
plot(Year, EMD, col=ifelse(D_EMD, "black", "red"),ylab = "EMD mg/L", pch=ifelse(D_EMD, 19, 17), cex = 0.7)

# Apply loess smoothing using the default span value of 0.8.  You can change the curve by changing the span value.
y.loess <- loess(y ~ x, span=0.1, data.frame(x=Year, y=EMD))

# Compute loess smoothed values for all points along the curve
y.predict <- predict(y.loess, data.frame(x=Year))

# Plots the curve.
lines(Year,y.predict)

#Add Legend to graph.  You can change the size of the box by changing cex = 0.75  Large # makes it larger.
legend("topleft", c("Smoothing Curve", "Detected", "NonDetect"), col = c(1, "black","red"), cex = 0.75,
       text.col = "black", lty = c(1 ,-1, -1), pch = c(-1, 19, 17),
       merge = TRUE, bg = 'gray90')

#Add title
title(main="Detects and NonDetects with Curve")
# Done
