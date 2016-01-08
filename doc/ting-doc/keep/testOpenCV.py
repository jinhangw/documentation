import cv
#to use in Windows, delete the above line and uncomment the following lines
#import cv2
#import cv2.cv as cv
import os
import sys

source = raw_input("source: ")
destination=raw_input("destination: ")
fps =int(30/int(raw_input("fps: ")))
capture = cv.CaptureFromFile(source)
numframes = int(raw_input ("duration(sec): "))*30
print "number of frames: "
print numframes
print "fps: "
print fps

os.chdir(destination)
for index in range (int(numframes)):
    frame = cv.QueryFrame(capture)
    if index % fps == 0:
        cv.SaveImage(str(index)+".jpg",frame)
        print index

