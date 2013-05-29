from datetime import datetime
from requests import HTTPError
from requests import ConnectionError
from pandas import *
from numpy import *
from matplotlib import pyplot as plt
from itertools import groupby

videogameD = read_csv("C:/Users/Xan/Documents/info480-master/project/videogamesales.csv")

print(videogameD) 

plt.bar(videogameD["Year"],videogameD["Global"]) # (x, y)
plt.title('Year by Platform') # plot title

plt.show() #