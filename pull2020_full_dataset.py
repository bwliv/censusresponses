import sys
sys.path.append('C:\\Users\\bwliv\\Anaconda3\\Lib\\site-packages')

import setuptools
import dateutil
import pytz
import numpy
import pandas as pd
import requests
import json

key = '2988f01f5e86175bda8beae2b5035e1ccef2d052'

url = f"https://api.census.gov/data/2020/dec/responserate?get=GEO_ID,CRRALL,CRRINT,DAVG,DINTAVG,DRRALL,DRRINT&key={key}&for=state:*"
JSONContent = requests.get(url).json()
temp = pd.DataFrame(JSONContent)
temp.columns = temp.iloc[0]
temp = temp.iloc[1:,-1]
states = [int(i) for i in temp]

labels = pd.DataFrame(JSONContent).iloc[0,:-1]

columns=labels

tract_responses = pd.DataFrame(columns=columns)

for i in states:
    if i < 10:
        url = f"https://api.census.gov/data/2020/dec/responserate?get=GEO_ID,CRRALL,CRRINT,DAVG,DINTAVG,DRRALL,DRRINT&key={key}&for=tract:*&in=state:0"        + str(i)
    else:
        url = f"https://api.census.gov/data/2020/dec/responserate?get=GEO_ID,CRRALL,CRRINT,DAVG,DINTAVG,DRRALL,DRRINT&key={key}&for=tract:*&in=state:"        + str(i)
    JSONContent = requests.get(url).json()
    temp = pd.DataFrame(JSONContent)
    temp.columns = temp.iloc[0]
    temp = temp.iloc[1:,0:-3]
    tract_responses = pd.concat([tract_responses,temp],sort=True)

county_responses = pd.DataFrame(columns=columns)

for i in states:
    if i < 10:
        url = f"https://api.census.gov/data/2020/dec/responserate?get=GEO_ID,CRRALL,CRRINT,DAVG,DINTAVG,DRRALL,DRRINT&key={key}&key={key}&for=county:*&in=state:0"        + str(i)
    else:
        url = f"https://api.census.gov/data/2020/dec/responserate?get=GEO_ID,CRRALL,CRRINT,DAVG,DINTAVG,DRRALL,DRRINT&key={key}&for=county:*&in=state:"        + str(i)
    JSONContent = requests.get(url).json()
    temp = pd.DataFrame(JSONContent)
    temp.columns = temp.iloc[0]
    temp = temp.iloc[1:,0:-2]
    county_responses = pd.concat([county_responses,temp],sort=True)

url = f"https://api.census.gov/data/2020/dec/responserate?get=GEO_ID,CRRALL,CRRINT,DAVG,DINTAVG,DRRALL,DRRINT&key={key}&for=state:*"
JSONContent = requests.get(url).json()
state_responses = pd.DataFrame(JSONContent)
state_responses.columns = state_responses.iloc[0]
state_responses = state_responses.iloc[1:,0:-1]

from datetime import datetime
date = str(datetime.date(datetime.now()))

tract_responses.to_csv('tract_responses_'+date+'.csv')
state_responses.to_csv('state_responses_'+date+'.csv')
county_responses.to_csv('county_responses_'+date+'.csv')
