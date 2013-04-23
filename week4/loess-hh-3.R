#Smoothing Curve with Confidence Interval Detects and NonDetects Together - does one line and ci for detects and another for NDs.  Special thanks to Kaori (Groton) Ito from the ggplot group for helping me on this one.
#Loads ggplot.  NOTE – You have to have ggplot installed
library(ggplot2)
#Loads data
mydata <-read.csv("http://ds101.seangoggins.net/Example-ND.csv", sep=",")
mydata$Detections <- ifelse(mydata$D_EMD==1, "Detected", "NonDetect")
ggplot(data = mydata, aes(x=Year, y=EMD, col=Detections)) +
  geom_point(aes(shape=Detections)) +
  geom_smooth(span=2, aes(group=1))+ 
  scale_colour_manual(values=c("black","red")) +
  theme(legend.position=c(0.2,0.9)) + 
  ggtitle("Smoothing Curve with Confidence Interval
Detects and NonDetects Together")
#Done