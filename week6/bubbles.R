# Load data
crime <- read.csv("crimeRatesByState2008.csv", header=TRUE, sep="\t")
symbols(crime$murder, crime$motor_vehicle_theft, circles=1)

# Wrong sizes for radius
symbols(crime$murder, crime$motor_vehicle_theft, circles=crime$population/1000)

# Correctly sized bubbles
radius <- sqrt( crime$population/ pi )
symbols(crime$murder, crime$motor_vehicle_theft, circles=radius)

# Try squares
symbols(crime$murder, crime$motor_vehicle_theft, squares=sqrt(crime$population), inches=0.5)

# Size circles smaller
symbols(crime$murder, crime$motor_vehicle_theft, circles=radius, inches=0.35, fg="white", bg="red", xlab="Murder Rate", ylab="Motor Vehicle Theft Rate")

# Add labels
text(crime$murder, crime$motor_vehicle_theft, crime$state, cex=0.5)
