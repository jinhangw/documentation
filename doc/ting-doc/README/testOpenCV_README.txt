testOpenCV.py

Ting Xu

--DESCRIPTION--

this is a python script that uses the opencv library to save the frames 
from a .mp4 video into images.

--USAGE--

The script can be run in both linux and Windows, but small adjustments 
need to be made. to use in Windows, delete or comment out the line "import cv" 
and add or uncomment the lines "import cv2" "import cv2.cv as cv"

to run, sinply execute the file, it will prompt for the following inputs:
<source> input video file, NOTE:the script has only been tested with .mp4 videos
<destination> output directory NOTE: will return error if directory not exist
<fps>: desired capture frame rate NOTE: minimum is 1
<duration>: duration of the video in seconds.


