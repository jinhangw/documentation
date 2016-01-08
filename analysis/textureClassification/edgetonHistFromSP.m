function desc = edgetonHistFromSP(im, edgeim, spmask, edgetonLibrary)
spmask = double(spmask);

%[edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(im);

edgeim = edgeim.*spmask;


[edgetonmap,desc] = edgetonify2(im, edgeim, edgetonLibrary);

%figure;
%imagesc(edgetonmap);

