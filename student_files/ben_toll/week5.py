from datetime import datetime
from requests import HTTPError
from requests import ConnectionError
from pandas import *
from numpy import *
from matplotlib import pyplot as plt
from itertools import groupby

nhlData = read_csv("./week4/nhlAgePoints.csv") # this is where the csv is located in relation to this script on my machine....

print(nhlData) # just to see what the data will look like

plt.bar(nhlData["Age"],nhlData["PTS"]) # (x, y)
plt.title('Age vs Points in the NHL') # plot title

plt.show() # show the plot yo.
