from xml.dom.minidom import *
import os
import glob


def createXML ():
    doc = Document()
    return doc
    
def createPhotoOverlay(kml_doc, file_name, file_iterator,coords):
  """Creates a PhotoOverlay element in the kml_doc element.

  Args:
    kml_doc: An XML document object.
    file_name: The name of the file.
    the_file: The file object.
    file_iterator: The file iterator, used to create the id.

  Returns:
    An XML element representing the PhotoOverlay.
  """

  photo_id = 'photo%s' % file_iterator

  kml = kml_doc.createElement('kml')
  kml.setAttribute('xmlns',"http://www.opengis.net/kml/2.2")
  
  document = kml_doc.createElement('Document')
  po = kml_doc.createElement('PhotoOverlay')
  po.setAttribute('id', photo_id)
  name = kml_doc.createElement('name')
  name.appendChild(kml_doc.createTextNode(file_name))
  description = kml_doc.createElement('description')
  description.appendChild(kml_doc.createCDATASection('<a href="#%s">'
                                                     'Click here to fly into '
                                                     'photo</a>' % photo_id))
  po.appendChild(name)
  po.appendChild(description)

  icon = kml_doc.createElement('Icon')
  href = kml_doc.createElement('href')
  href.appendChild(kml_doc.createTextNode(file_name))

  camera = kml_doc.createElement('Camera')
  longitude = kml_doc.createElement('longitude')
  latitude = kml_doc.createElement('latitude')
  altitude = kml_doc.createElement('altitude')
  tilt = kml_doc.createElement('tilt')

  # Determines the proportions of the image and uses them to set FOV.
  width = 2592
  length = 1944
  lf = str(width/length * -20.0)
  rf = str(width/length * 20.0)

  longitude.appendChild(kml_doc.createTextNode(str(coords[1])))
  latitude.appendChild(kml_doc.createTextNode(str(coords[0])))
  altitude.appendChild(kml_doc.createTextNode('10'))
  tilt.appendChild(kml_doc.createTextNode('90'))
  camera.appendChild(longitude)
  camera.appendChild(latitude)
  camera.appendChild(altitude)
  camera.appendChild(tilt)

  icon.appendChild(href)

  viewvolume = kml_doc.createElement('ViewVolume')
  leftfov = kml_doc.createElement('leftFov')
  rightfov = kml_doc.createElement('rightFov')
  bottomfov = kml_doc.createElement('bottomFov')
  topfov = kml_doc.createElement('topFov')
  near = kml_doc.createElement('near')
  leftfov.appendChild(kml_doc.createTextNode(lf))
  rightfov.appendChild(kml_doc.createTextNode(rf))
  bottomfov.appendChild(kml_doc.createTextNode('-20'))
  topfov.appendChild(kml_doc.createTextNode('20'))
  near.appendChild(kml_doc.createTextNode('10'))
  viewvolume.appendChild(leftfov)
  viewvolume.appendChild(rightfov)
  viewvolume.appendChild(bottomfov)
  viewvolume.appendChild(topfov)
  viewvolume.appendChild(near)

  po.appendChild(camera)
  po.appendChild(icon)
  po.appendChild(viewvolume)
  point = kml_doc.createElement('Point')
  coordinates = kml_doc.createElement('coordinates')
  coordinates.appendChild(kml_doc.createTextNode('%s,%s,%s' %(coords[1],
                                                              coords[0],
                                                              coords[2])))
  point.appendChild(coordinates)

  po.appendChild(point)

  document.appendChild(po)

  kml.appendChild(document)
  return kml

def createMultiPhotoOverlay(directory,startingIndex):
    print"running"

     # Constants,can be changed to suit different types of location tags
    kmlFileName = startingIndex
    os.chdir(directory)
    print directory
    fileIndex = startingIndex;
    coordDict = {}
    dictIndex = startingIndex;
    name = "Photo Overlays"
    description = "PhotoOverlay showing road surface conditions"
    kmlMain = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<kml xmlns="http://www.opengis.net/kml/2.2">\n'
        '<Folder>\n'
        '<name>Network Links</name>\n'
        )

    # Reads geographic data from data.txt
    f = open("D:/Research/photoOverlayData.txt",'r')
    for lines in f:
        coordDict[dictIndex]=lines.split(',')
        dictIndex+=1

    # Creates individual kml files by going through all .jpg photos in a directory
    for files in glob.glob("*.jpg"):
        kmlFileAddr = 'D:/Research/kml/PhotoOverlayTest00'+str(kmlFileName)+'.kml'
        href = "D:\Research\Images\\" + files

    # Adds link to the kml file in the top level kml file    
        kmlHeader = (
            '<NetworkLink>\n'
            '<Link>\n'
            '<href>'+ kmlFileAddr+ '</href>\n'
            '</Link>'
            '</NetworkLink>')
        kmlMain += kmlHeader

        coords = coordDict[fileIndex]

        # Creates kml file for individual photo
        doc = createXML()
        kml = createPhotoOverlay(doc, href, 001,coords)
        print "creating "+kmlFileAddr
        f = open(kmlFileAddr, 'w')
        try:
            f.write(kml.toprettyxml(indent="  "))
        finally:
            f.close()

        kmlFileName+=1
        fileIndex+=1


# Creates top level kml file   
    kmlMain += (
      '</Folder>\n'
      '</kml>\n')
    f =  open("D:/Research/kml/openMultipleKml.kml",'w')
    f.write(kmlMain)
    f.close()


createMultiPhotoOverlay("D:/Research/Images",1)


