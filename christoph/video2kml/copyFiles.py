import os
import shutil
import sys

destDir = sys.argv[2]
if not os.path.exists(destDir):
	os.makedirs(destDir)
with open(sys.argv[1]) as f:
	for line in f:
		fileToCopy = line.split("\n")[0]
		fileName = fileToCopy.split("/")[len(fileToCopy.split("/"))-1]
		folderName = fileToCopy.split("/")[len(fileToCopy.split("/"))-2]
	
		if not os.path.exists(destDir+ '/' + folderName):
			os.makedirs(destDir+ '/' + folderName)
		destFile = destDir + '/' + folderName + '/' + fileName
		if not os.path.exists(fileToCopy):
			print fileName + " cannot be found"
			continue
		if not os.path.exists(destFile):
			shutil.copyfile(fileToCopy,destFile)
			print fileName + " copied to " + destFile
		else:
			print fileName + " already present"
			


