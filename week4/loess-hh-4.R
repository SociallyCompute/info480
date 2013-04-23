#Plots Detects and NonDetects and does separate curves and CIs
#Loads ggplot.  NOTE – You have to have ggplot installed
library(ggplot2)
#Loads data from internet
mydata <-read.csv("http://ds101.seangoggins.net/Example-ND.csv", sep=",")
#Makes a new column of Detected and NonDetects based on D_EMD
mydata$Detections <- ifelse(mydata$D_EMD==1, "Detected", "NonDetect")

ggplot(data = mydata, aes(x=Year, y=EMD, col=Detections)) +
  geom_point(aes(shape=Detections)) +
  geom_smooth(span=2)+ 
  scale_colour_manual(values=c("black","red")) +
  theme(legend.position=c(0.2,0.9))+
  ggtitle("Detects and NonDetects with Separate Curves and CIs")
#done