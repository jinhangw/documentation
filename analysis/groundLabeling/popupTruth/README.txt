Automatic Photo Pop-up Data (SIGGRAPH 2005)
Authors: Derek Hoiem (dhoiem@cs.cmu.edu), Alexei Efros, Martial Hebert
June 30, 2005

The .jpg files are the images.  The .pnm files are an oversegmentation
of the images, computed by Pedro Felzenszwalb's algorithm:
people.cs.uchicago/~pff/segment/

The ground truth files contain the image name, the oversegmentation 
(1..N_s indicate segments) , the adjacency matrix for the segments, 
the number of pixels in each segment, and the ground truth labels
(0: unlabeled, 1: ground, 2: vertical, 3: sky) for each segment.  


