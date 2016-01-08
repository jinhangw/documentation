import cv2
import os
import sys



def main():


    if len(sys.argv) < 3:
        print "Error: Need to specify the video data file and the result directory"
        return

    capture = cv2.CaptureFromFile(sys.argv[1])
    print "number of frames: "
    numframes = int(cv2.GetCaptureProperty(capture,cv2.CV_CAP_PROP_FRAME_COUNT))
    print int(numframes)

    os.chdir(sys.argv[2])
    for index in range (int(numframes)):
        frame = cv2.QueryFrame(capture)
        if index<10:
            cv2.SaveImage("img000"+str(index)+".jpg",frame)
        elif index<100:
            cv2.SaveImage("img00"+str(index)+".jpg",frame)
        elif index<1000:
            cv2.SaveImage("img0"+str(index)+".jpg",frame)
        else:
            cv2.SaveImage("img"+str(index)+".jpg",frame)
        
        print index




if __name__ == '__main__':
    main()
