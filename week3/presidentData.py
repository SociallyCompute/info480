from datetime import datetime
from requests import HTTPError
from requests import ConnectionError
from pandas import *
from numpy import *
from matplotlib import pyplot as plt
from itertools import groupby

presidentData = read_csv("http://ds101.seangoggins.net/presidents.csv", 
    header=None)

plt.plot(presidentData[2])

plt.show()