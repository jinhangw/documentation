import cv
import os
capture = cv.CaptureFromFile("testmp4.mp4")
print "number of frames: "
numframes = int(cv.GetCaptureProperty(capture,cv.CV_CAP_PROP_FRAME_COUNT))
print int(numframes)

os.chdir("/home/ting/Desktop/Research/output Images")
for index in range (int(numframes)):
    frame = cv.QueryFrame(capture)
    cv.SaveImage("img"+str(index)+".png",frame)
    print index
