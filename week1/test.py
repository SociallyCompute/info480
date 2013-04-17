import argparse, collections, configparser, json, math, mysql.connector as sql, requests, sys, time
from datetime import datetime
from mysql.connector import errorcode
from requests import HTTPError
from requests import ConnectionError
from requests_oauthlib import OAuth1
from pandas import *

parasiteData = read_csv("https://raw.github.com/rhiever/ipython-notebook-workshop/master/parasite_data.csv", # name of the data file
    sep=",", # what character separates each column?
    na_values=["", " "]) # what values should be considered "blank" values?
    
#%R -i parasiteData print(summary(parasiteData))  
#%R -i parasiteData plot(V3 ~ V2, data = parasiteData, xlab="Replicate", ylab="Shannon Diversity")  

# Connect to MySQL using config entries
def connect() :
    config = configparser.ConfigParser()
    config.read("config/settings.cfg")

    db_params = {
        'user' : config["MySQL"]["user"],
        'password' : config["MySQL"]["password"],
        'host' : config["MySQL"]["host"],
        'port' : int(config["MySQL"]["port"]),
        'database' : config["MySQL"]['database'],
        'charset' : 'utf8',
        'collation' : 'utf8_general_ci',
        'buffered' : True
    }

    return sql.connect(**db_params)

# Get All Institutions from the database
def getInstitutions(conn) : 
    cursor = conn.cursor() 
    query = ("select * from DW_Institution_Dim")
    cursor.execute(query)
    return cursor

# Main Function
try :
    conn = connect()
        
        #get all the institutions
        
    institutions = getInstitutions(conn)
        
    for (institution_id, institution_name) in institutions :
        print(institution_id, institution_name)