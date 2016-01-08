function [D, C, F] = dfviewdata(dataset)
% DFVIEWDATA Helper function for the Curve Fitting toolbox viewdata panel
%
%    [X, Y, W] = DFVIEWDATA(DATASET)
%    returns the x, y and w values for the given dataset
%	 (in a manner that the Java GUI can use)

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.1 $  $Date: 2012/09/25 15:40:54 $

ds = handle(dataset);
D = ds.y;
C = ds.censored;
F = ds.frequency;
