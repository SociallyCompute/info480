#Load your data.  The data is in a spreadsheet named KW-spreadsheet and we are going to call it "data" in R
mydata <- read.csv("http://ds101.seangoggins.net/example-smoothing-data.csv", sep=",")
attach(mydata)

#Plots the Y and X axis
plot( Date, dataset1, 
      
      #sets the range of the y axis
      ylim=range(5.7,7.5),
      
      #sets the symbol type, size, and color for the 1st series
      pch=20,cex=0.0, col='black', xlab="Date ", ylab="pH")

#Plots the second series
points( Date, dataset2,
        #sets the symbol type, size, and color for the 2nd series
        col='blue',pch=20, cex=0.0)

#Plots the 3rd series
points( Date, dataset3,
        #sets the symbol type, size, and color for the 3rd series
        col='red',pch=20, cex=0.0)

#Plots the 4th series
points( Date, dataset4,
        #sets the symbol type, size, and color for the 4th series
        col='forestgreen',pch=20, cex=0.0)

#Plots the 5th series
points( Date, dataset5,
        #sets the symbol type, size, and color for the 5th series
        col='purple',pch=20, cex=0.0)

#Plots the 6th series
points( Date, dataset6,
        #sets the symbol type, size, and color for the 6th series
        col='orange',pch=2, cex=0.0)

#Plots the 7th series
points( Date, dataset7,
        #sets the symbol type, size, and color for the 7th series
        col='limegreen',pch=2, cex=0.0)

#Plots the 8th series
points( Date, dataset7,
        #sets the symbol type, size, and color for the 8th series
        col='red',pch=2, cex=0.0)

#Plots the 9th series
points( Date, dataset7,
        #sets the symbol type, size, and color for the 9th series
        col='forestgreen',pch=2, cex=0.0)

#draw the smooth lines.  NOTE-the span will adjust how much it is smooth
lines( loess.smooth(Date,dataset1, span = 0.3),col='black', lwd=4, lty=1)
lines( loess.smooth(Date,dataset2, span = 0.3),col='blue',lwd=4, lty=1)
lines( loess.smooth(Date,dataset3, span = 0.3),col='red',lwd=4, lty=1)
lines( loess.smooth(Date,dataset4, span = 0.3),col='forestgreen',lwd=3, lty=1)
lines( loess.smooth(Date,dataset5, span = 0.3),col='purple',lwd=3, lty=1)
lines( loess.smooth(Date,dataset6, span = 0.3),col='orange',lwd=3, lty=1)
lines( loess.smooth(Date,dataset7, span = 0.3),col='limegreen',lwd=3, lty=1)
lines( loess.smooth(Date,dataset8, span = 0.3),col='gray49',lwd=3, lty=1)
lines( loess.smooth(Date,dataset9, span = 0.3),col='yellow',lwd=3, lty=1)

#Add Legend to graph.  You can change the size of the box by changing cex = 0.75  Large # makes it larger.
legend("bottomleft",c("Dataset1","Dataset2", "Dataset3", "Dataset4", "Dataset5", "Dataset6", "Dataset7", "Dataset8", "Dataset9"),
       col = c("black","blue", "forestgreen","red", "purple", "orange", "limegreen", "gray49", "yellow"),
       cex = 0.7,text.col = "black",lty = c(1),lwd=c(3),pch = c(-1),
       merge = TRUE, bg = 'gray90')

#Add title
title(main="Locally Weighted Scatterplot Smoothing Curve")
#done