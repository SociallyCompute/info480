from pylab import *

x = array([ 0.0, 0.63, 1.26, 1.89, 2.51, 3.14, 3.77, 4.40, 5.03, 5.65 ])
y = array([ 0.0, 0.59, 0.95, 0.95, 0.59, 0.00, -0.59, -0.95, -0.95, -0.59])

px = arange( 0.0, 5.65, 5.65/50)
py = []
for order in range(1,6) :
    p = polyfit(x,y, order)
    py.append( polyval(p,px) )

figure(1, figsize=(6.0,4.0), dpi=100)
plot( x, y, "rx")
for ye in py :
    plot(px,ye)
legend( [ "order %d" % i for i in range(6) ] )
title( 'polynomial interpolate')

savefig( 'poly_interpolate.png' )