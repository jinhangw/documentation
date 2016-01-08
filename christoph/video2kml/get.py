# opens gps file and gets parameters- time and coordinates
# TODO: parse date + how to use date parameter in GET req 

import sys
import os
import glob
import urllib
import json

path = sys.argv[1]
#path = "20130524_061236_335/"
#for infile in glob.glob(os.path.join(path, '*gps.txt')):

f = open(path, 'r')
# read line from gps text file

TIME_GPS=f.readline()
#print(TIME_GPS)
# sample data : 20130524_061239_860: -79.96206035043694, 40.43782014869297
paras = TIME_GPS.split(":")
#print(paras)
# time
time = paras[0]
YYYYMMDD = time[:8]
HH = time[9:11]
# geo coordinates
coords = (paras[1]).split(",")
YYYY = YYYYMMDD[:4]
MM = YYYYMMDD[4:6]
DD = YYYYMMDD[6:8]

opener = urllib.FancyURLopener({})
APIkey = "4d53ca5971e81aa7e60f1bfecf462f01"

f = opener.open("https://api.forecast.io/forecast/%s/%s,%s,%s-%s-%sT%s:00:00-0400" % (APIkey,coords[1][1:-1],coords[0][1:-1],YYYY,MM,DD,HH))
#print(("https://api.forecast.io/forecast/%s/%s,%s,%s-%s-%sT%s:00:00-0400" % (APIkey,coords[1][1:-1],coords[0][1:-1],YYYY,MM,DD,HH)))
print f.read()
