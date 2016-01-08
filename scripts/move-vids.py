import shutil, time, os

def main():
    pause_time = 10
    src = '/home/pork/Dropbox/Apps/Roadvid/'
    dst = '/home/pork/Desktop/ResearchData/video-data/'
    images = []
    log = open('log.out', 'a') 
    while True:
	print "Checking for files..."
	images = os.listdir(src)
	time.sleep(pause_time)
        for img in images:
	    if img in os.listdir(dst):
                os.remove(src + img)
	        print "removed dublicate file " + img
		continue
	    shutil.move(src + img, dst)
	    print "Moved file " + img
	    log.write(img + '\n')


if __name__ == '__main__':
    main()
