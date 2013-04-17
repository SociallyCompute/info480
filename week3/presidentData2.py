from pandas import *
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt

presidentData = read_csv("http://ds101.seangoggins.net/presidents.csv", 
    header=None)

xs = np.linspace(presidentData[2].min()-1, presidentData[2].max()+1, 45)

kde1 = stats.gaussian_kde(presidentData[2])
kde2 = stats.gaussian_kde(presidentData[2], bw_method='silverman')
fig = plt.figure(figsize=(16, 12))

apresidentData = fig.add_subplot(211)
apresidentData.plot(presidentData[2], np.zeros(presidentData.shape), 'b+', ms=40) # rug plot
apresidentData.plot(xs, kde1(xs), 'k-', label="Scott's Rule")
apresidentData.plot(xs, kde2(xs), 'b-', label="Silverman's Rule")
#apresidentData.plot(xs, stats.norm.pdf(xs), 'r--', label="True PDF")
 
apresidentData.set_xlabel('x')
apresidentData.set_ylabel('Density')
apresidentData.set_title("Normal (top) and Presidents T$_{df=45}$ (bottom) distributions")
apresidentData.legend(loc=1)

plt.show()