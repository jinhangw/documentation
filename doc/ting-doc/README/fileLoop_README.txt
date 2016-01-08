fileLoop.py

Ting Xu

--DESCRIPTION--

This file contains several test scripts for development with kml-generating scripts.
It has the following functions:

get_exif(fn): takes in the file name of an image and extracts the exif data from the 
              image, which is placed in a python dictionary.

getGPS(fn):   takes in the file name of an image and generates a string with GPS info 
              for the <latlongbox> field in the .kml file. converts GPS value from degree to decimal

getLoc(fn):   takes in the file name of an image and generates a string in the format of "latitued, longitude"
              converts GPS values from degree to decimal

makeGroundOverlayData(path,output):  takes in the path to the input directory of photos <path> and the file name 
                                     output file <output> as arguments, and goes through all photos in the input
                                     directory and calls getGPS(fn), which generates the latlonbox string.
                                     saves output string from getGPS(fn) to output file specified.
				     
                                     test output file: groundOverlayData.txt

makeLoc(path,output):		     takes in the path to the input directory of photos <path> and the file name 
                                     output file <output> as arguments, and goes through all photos in the input
                                     directory and calls getLoc(fn), which generates the GPS string.
                                     saves output string from getLoc(fn) to output file specified.	
			     
                                     test output file: loc.txt

makePhotoOverlayData(path,output):   takes in the path to the input directory of photos <path> and the file name 
                                     output file <output> as arguments, and goes through all photos in the input
                                     directory and calls getLoc(fn), which generates the GPS string.
                                     saves output string in the format "latitude, longitude, 15" for use to create 
                                     photo overlay .kml files.
				     
                                     test output file: photoOverlayData.txt