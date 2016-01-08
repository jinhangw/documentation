cvNamedWindow("Example2", CV_WINDOW_AUTOSIZE);
capture = cvCreateFileCapture( argv[1]);
while(1) :
    frame = cvQueryFrame(capture);
    if(frame==0): break;
    cvShowImage("Example2", frame);
    c = cvWaitKey(33);
    if(c==27): break;
    
cvReleaseCapture(capture);
cvDestroyWindow("Example2");

