import shutil, time, os

pauseTime = 10
log = open('log.out', 'a')

def moveFiles(src, dst):
    files = os.listdir(src)
    for f in files:
        if f in os.listdir(dst):
            os.remove(src + f)
            print "\tRemoved duplicate file " + f
            continue
        shutil.move(src + f, dst)
        print "\tMoved file " + f 
    	log.write(f + '\n')


def main():
    vidSrc = '/home/pork/Dropbox/Apps/Vehicle State/vid/'
    imgSrc = '/home/pork/Dropbox/Apps/Vehicle State/img/'
    vidDst = '/home/pork/Desktop/ResearchData/video-data/'
    imgDst = '/home/pork/Desktop/ResearchData/photo-data/2013/'
    while True:
        print "Checking for video files..."
	moveFiles(vidSrc, vidDst)
        print "Checking for image files..."
	moveFiles(imgSrc, imgDst)
	time.sleep(pauseTime)

main() 	
