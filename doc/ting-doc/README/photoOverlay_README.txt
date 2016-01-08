photoOverlay.py

Ting Xu

--DESCRIPTION--

this is a python script that generates one or multiple .kml files for Google Earth.
Specifically, it generates .kml files that will create a photo overlay of a specified
image within Google Earth using GPS data.

--USAGE--

to run, call the desired function with valid arguments

createPhotoOverlay: creates a single .kml file, has the following arguments:
                    <kml_doc> output file name
		    <file_name> input file name
	            <file_iterator> output file iterator
                    <coords> GPS data



createMultiPhotoOverlay: goes through a directory and creates a .kml file for each JPEG image found.
                         arguments:
                         <directory> the input directory
                         <startingIndex> an arbitrary number for dictioanry indexes. use 1 in most cases