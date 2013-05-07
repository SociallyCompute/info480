

jivethreadmessagedistribution <- read.csv("jivethreadmessagedistribution.csv")
plot(jivethreadmessagedistribution$threadID, log(jivethreadmessagedistribution$counter))


jive2 <- read.csv("mathforum-c.csv")
plot(jive2$threadID, log(jive2$counter))