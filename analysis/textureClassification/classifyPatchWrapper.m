function labelimage = classifyPatchWrapper(filename, svmModel, filterBank, TextonLibrary, EdgetonLibrary)

testimg = imread(filename);

[h,w,c] = size(testimg);
if(w>800)
   testimg  = imresize(testimg, [NaN 800]);
end


labelimage = classifyPatch(testimg, svmModel, filterBank, TextonLibrary, EdgetonLibrary, false);
%imagesc(labelimage);


