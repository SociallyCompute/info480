# Make example reproducible
set.seed(19)

period <- 120

# Create sine curve with noise
x <- 1:120
y <- sin(2*pi*x/period) + runif(length(x),-1,1)

# Plot points on noisy curve
plot(x,y, main="Sine Curve + 'Uniform' Noise")
mtext("showing loess smoothing (local regression smoothing)")

spanlist <- c(0.10, 0.25, 0.50, 0.75, 1.00, 2.00)
for (i in 1:length(spanlist))
{
  y.loess <- loess(y ~ x, span=spanlist[i], data.frame(x=x, y=y))
  y.predict <- predict(y.loess, data.frame(x=x))
  
  # Plot the loess smoothed curve
  lines(x,y.predict,col=i)
  
  # Find peak point on smoothed curve
  peak <- optimize(function(x, model)
    predict(model, data.frame(x=x)),
                   c(min(x),max(x)),
                   maximum=TRUE,
                   model=y.loess)
  # Show position of smoothed curve maximum
  points(peak$maximum,peak$objective, pch=FILLED.CIRCLE<-19, col=i)
}

legend (0,-0.8,
        c(paste("span=", formatC(spanlist, digits=2, format="f"))),
        lty=SOLID<-1, col=1:length(spanlist), bty="n")