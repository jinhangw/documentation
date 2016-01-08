name = "Ground Overlays"
description = "Overlay shows Mount Etna erupting on July 13th, 2001."
href = "D:\Research\ewWAk.jpg"
north = 40.44490
south = 40.4448
east = -79.9429
west = -79.9430
rotation = -0.1556640799496235



kml = (
   '<?xml version="1.0" encoding="UTF-8"?>\n'
   '<kml xmlns="http://www.opengis.net/kml/2.2">\n'
   '<Folder>\n'
   '<name>%s</name>\n'
   '<description>Examples of ground overlays</description>\n'
   '<GroundOverlay>\n'
   '<name>Large-scale overlay on terrain</name>\n'
   '<description>%s</description>\n'
   '<Icon>\n'
   '<href>%s</href>\n'
   '</Icon>\n'
   '<LatLonBox>\n'
   '<north>%f</north>\n'
   '<south>%f</south>\n'
   '<east>%f</east>\n'
   '<west>%f</west>\n'
   '<rotation>%f</rotation>\n'
   '</LatLonBox>\n'
   '</GroundOverlay>\n'
   '</Folder>\n'
   '</kml>\n'
   ) %(name, description, href, north, south, east, west, rotation)

f = open('D:/Research/kml/test02.kml', 'w')
f.write(kml)
f.close()
