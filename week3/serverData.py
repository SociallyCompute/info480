from datetime import datetime
from requests import HTTPError
from requests import ConnectionError
from pandas import *
from numpy import *
from matplotlib import pyplot as plt
from itertools import groupby

serverData = read_csv("http://ds101.seangoggins.net/ch02_serverdata", 
    header=None, )

### Look at 40 bins
#plt.hist(serverData[0], bins=45)

### Look at 200 bins
plt.hist(serverData[0], bins=200)

plt.show()

# This will plot a line graph
# plt.plot(serverData[0])
