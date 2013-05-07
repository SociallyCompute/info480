# library
library(ggplot2)

# Datasets
prc <- read.csv("http://ichart.finance.yahoo.com/table.csv?s=^GSPC&d=0&e=1&f=2013&g=m&a=0&b=1&c=1990&ignore=.csv", as.is=T)
vix <- read.csv("http://ichart.finance.yahoo.com/table.csv?s=%5EVIX&a=00&b=2&c=1990&d=0&e=1&f=2013&g=m&ignore=.csv", as.is=T)

# Data processing
prc$Date <- as.Date(prc$Date)
prc <- prc[, c(1,7)]
colnames(prc)[2] <-c("Value")

vix$Date <- as.Date(vix$Date)
vix <- vix[, c(1,5)]
colnames(vix)[2] <-c("VIX")

df <- merge(prc, vix)
df$year <- as.integer(substring(df$Date,1,4))
df$month <- as.integer(substring(df$Date,6,7))

# Graphs
par(mfrow=c(2,1))
plot(df$Date, df$Value, type="l",main="S&P500",  xlab="", ylab="")
plot(df$Date, df$VIX, type="l",main="VIX ( VOLATILITY S&P 500) ",  xlab="", ylab="")

# Erase
frame()
par(mfrow=c(1,1)) 

# ggplot2 base layer
p <- ggplot(df)

# Line graph
(p + geom_line(aes(x=Date, y=Value, colour=VIX)) +
   scale_colour_gradient(low="blue", high="red")
)

# Bubble plots
(p + geom_point(aes(x = month, y = year, size = Value, colour = VIX),shape=16, alpha=0.80) +
   scale_colour_gradient(limits = c(10, 60), low="blue", high="red", breaks= seq(10, 60, by = 10))  +
   scale_x_continuous(breaks = 1:12, labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) +
   scale_y_continuous(trans = "reverse")
)

# fin.