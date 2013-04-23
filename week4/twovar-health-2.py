# -*- coding: utf-8 -*-
#importing the required libraries
from pandas import *
import matplotlib
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import matplotlib.mlab as mlabimport 


r = read_csv("http://ds101.seangoggins.net/HealthExpenditure.csv", 
    header=0)

# Create a figure with size 6 x 6 inches.
fig = Figure(figsize=(6,6))

# Create a canvas and add the figure to it.
canvas = FigureCanvas(fig)

# Create a subplot.
ax = fig.add_subplot(111)

# Set the title.
ax.set_title('Health Expenditure Across The World',fontsize=14)

# Set the X Axis label.
ax.set_xlabel('Expenditure per person (US Dollars)',fontsize=12)
# Set the Y Axis label.
ax.set_ylabel('Average Doctor Visits',fontsize=12)

# Display Grid.
ax.grid(True,linestyle='-',color='0.75')

# Generate the Scatter Plot.
ax.scatter(r.Expenditure,r.Doctor_Visits,s=20,color='tomato');

# Save the generated Scatter Plot to a PNG file.
canvas.print_figure('./healthvsexpense-2.png',dpi=500)

 