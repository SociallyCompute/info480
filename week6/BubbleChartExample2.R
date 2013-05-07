library(ggplot2)

#Bubble Chart
data <- textConnection("Month,Series 1,Series 2,Value
                       Jan,3.9543031342,3.9562676987,4.1058940301
                       Feb,9.9728079932,2.9912424739,7.7609955473
                       Mar,2.9840194434,3.8122830028,9.0522239916
                       Apr,2.4148084549,3.0404574145,0.7286977116
                       May,5.685720793,0.9677886777,7.222444592
                       Jun,9.9094119668,5.6243130472,7.6263150014
                       Jul,7.4870035704,7.8294275608,5.4762881855
                       Aug,4.0690666856,9.1890754923,9.9755757954
                       Sep,8.8038171316,0.7918713801,9.5024713082
                       Oct,5.7545989705,8.982290877,8.0353516852
                       Nov,7.5449426472,5.3628405277,0.155836856
                       Dec,7.8511308506,3.2607904961,9.1500398843
                       ")

data <- read.csv(data, h=T)
data$Month <- factor(data$Month, data$Month)

p <- ggplot(aes(x=Series.1, y=Series.2, size=Value, colour="blue"), data=data)
p + geom_point() +
  scale_colour_identity() +
  scale_size_continuous('Legend Title', range = c(0, 20)) +
  labs(x="X Label", y="Y Label", title="An Example Bubble Chart")
# full output: http://www.yaksis.com/static/img/03/large/BubbleChart.png
