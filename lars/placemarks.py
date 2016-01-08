import sys

kmlheader = """<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
"""
kmlplacemark = """<Placemark>
    <name>Simple placemark</name>
    <description>%s</description>
    <Point>
      <coordinates>%s,%s,0</coordinates>
    </Point>
  </Placemark>
"""
kmlfooter = """</Document>
</kml>"""

cdata = ''' <![CDATA[
        <img style="width: 600px; height: 400px;" src="%s">
            ]]> '''

href = '<img src="%d" />'

def main():

    relative = False
    windows = True
    for arg in sys.argv:
        if arg == '-r':
            relative = True
        elif arg == '-w':
            windows = True
        elif arg == '--help' or arg == '-h':
            print "    Usage: \npython placemarks.py <path to datafile> <directory containing images> <flags>\n\nflags:\n-r (if you want the links to be relative, note: it is not necessary to specify absolute paths to either the datafile or the image directory)\n-w (if this is intended to be opened on windows)"
            return
    if len(sys.argv) < 3:
        print "Error: Need to specify the image data file and the image directory"
        return
    datafile = open(sys.argv[1], 'r').read().split('\n')
    imgdir = sys.argv[2]
    imgs = []
    for line in datafile:
        if line == '': continue
        line = line.split('||')
        print line
        imgs.append({'file' : line[0], 'coords' : (line[1].split(', ')[0], line[1].split(', ')[1])})
    rawkml = kmlheader
    for img in imgs:
        if relative:
            imgfile = img['file']
        else:
            imgfile = os.path.abspath(img['file'])
        if windows:
            imglink = cdata % imgfile
        else:
            imglink = href % imgfile
        rawkml += kmlplacemark % (imglink, img['coords'][0], img['coords'][1])
    rawkml += kmlfooter
    open("out.kml", 'w').write(rawkml)



if __name__ == '__main__':
    main()
