import glob
import os

def createGroundOverlay():
    print "running"
    # Constants,can be changed to suit different types of location tags
    kmlFileName = 001
    os.chdir("/media/vboxshared/Images")
    fileIndex = 1;
    latLonBoxDict = {}
    dictIndex = 1;
    name = "Ground Overlays"
    description = "Overlay shows road surface conditions"
    kmlMain = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<kml xmlns="http://www.opengis.net/kml/2.2">\n'
        '<Folder>\n'
        '<name>Network Links</name>\n'
        )


    # Reads geographic data from data.txt
    f = open("/media/vboxshared/groundOverlayData.txt",'r')
    for lines in f:
        latLonBoxDict[dictIndex]=lines.split(',')
        dictIndex+=1
        


    # Creates individual kml files by going through all .jpg photos in a directory
    for files in glob.glob("*.jpg"):
        kmlFileAddr = '/media/vboxshared/kml/test'+str(kmlFileName)+'.kml'
        href = "/media/vboxshared/Images/" + files

        # Adds link to the kml file in the top level kml file    
        kmlHeader = (
            '<NetworkLink>\n'
            '<Link>\n'
            '<href>'+ kmlFileAddr+ '</href>\n'
            '</Link>'
            '</NetworkLink>')
        kmlMain += kmlHeader

        # Creates latLonBox data
        north=float(latLonBoxDict[fileIndex][0])
        south=float(latLonBoxDict[fileIndex][1])
        east=float(latLonBoxDict[fileIndex][2])
        west=float(latLonBoxDict[fileIndex][3])
        rotation = float(latLonBoxDict[fileIndex][4])
        # Standard kml header
        kml = (
           '<?xml version="1.0" encoding="UTF-8"?>\n'
           '<kml xmlns="http://www.opengis.net/kml/2.2">\n'
           '<Folder>\n'
           '<name>%s</name>\n'
           '<description>Examples of ground overlays</description>\n'
           '<GroundOverlay>\n'
           '<name>Small-scale overlay on terrain' + str(kmlFileName) + '</name>\n'
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

        # Creates kml file for individual photo
        f = open(kmlFileAddr, 'w')
        f.write(kml)
        f.close()

        kmlFileName+=1
        fileIndex+=1
        
    # Creates top level kml file   
    kmlMain += (
      '</Folder>\n'
      '</kml>\n')
    f =  open("/media/vboxshared/kml/openMultipleGroundKml.kml",'w')
    f.write(kmlMain)
    f.close()

createGroundOverlay()
