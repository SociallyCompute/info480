from numpy import *
from matplotlib import pyplot as plt

from itertools import groupby

CA = [0,4,0,3,0,5]  
CB = [0,0,4,4,2,2,2,2,3,0,5]  

x = []
y = []
for indx, klass in enumerate([CA, CB]):
    klass = groupby(sorted(klass))
    for item, objt in klass:
        objt = list(objt)
        points = len(objt)
        pos = 1 + indx + (1 - points) / 50.
        for item in objt:
            x.append(pos)
            y.append(item)
            pos += 0.04

plt.plot(x, y, 'o')
plt.xlim((0,3))

plt.show()