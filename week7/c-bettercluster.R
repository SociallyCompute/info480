europe <-read.csv("europe.csv")
euroclust<-hclust(dist(europe[-1]))
plot(euroclust, labels=europe$Country)
rect.hclust(euroclust, 7)
