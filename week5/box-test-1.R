x <- rnorm (10000)
Box.test (x, lag = 1)
Box.test (x, lag = 1, type = "Ljung")
