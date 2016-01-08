createGroundOverlayKml.py

Ting Xu

---DESCRIPTION---

This is a python script for generating .kml files for Google Earth. 
Specifically, it creates .kml files to overlay photos in a given directory 
inside Google Earth, using GPS data frome a separate .txt file. It is designed
for the output of the RoadCam android app

--USAGE--

the main function, createGroundOveraly has 2 arguments. The first argument <path> is 
the path to the directory that contains all of the photos for overlay. The second
argument <kmlPath> is the path to output directory that contains the generated .kml files.

to use this script, simply run the main function with 2 valid arguments.

Note: if the output directory does exist the function will issue a warning and will create
a new output directory with the specified path.


