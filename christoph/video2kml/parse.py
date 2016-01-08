import sys
import json

"""
kind of data:
sunny, overcast, rainy, snow: 1/0
heavy downpour 1/0
rain depth (inches)

note: data for HHMMSS has weather data for multiple hours?
"""
jsonfile = sys.argv[1]
#print(jsonfile)
#video-data/20130531_080242_028/20130531_080242_028-weather-data.json
json_data = open(jsonfile)

data = json.load(json_data)

print(data["timezone"]+" "+ str(data["currently"]["time"])+" "+str(data["currently"]["temperature"])+" "+str(data["currently"]["cloudCover"])+" "+str(data["currently"]["precipIntensity"])+" "+data["currently"]["summary"])
print("timezone time temperature cloudCover precipIntensity summary")
