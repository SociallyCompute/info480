from pylab import *
import scipy.interpolate

data_x = [ 0.0, 0.63, 1.26, 1.89, 2.51, 3.14, 3.77, 4.40, 5.03, 5.65 ]
data_y = [ 0.0, 0.59, 0.95, 0.95, 0.59, 0.00, -0.59, -0.95, -0.95, -0.59]

spl = scipy.interpolate.splrep(data_x, data_y)

figure(1, figsize=(6.0,4.0), dpi=100)

x = arange( 0.0, 5.65, 5.65/50)
y = scipy.interpolate.splev( x, spl)
plot( x, y, "bo" )

plot( data_x, data_y, "rs" )
title( 'scipy spline interpolation' )
savefig( 'spline.png' )
