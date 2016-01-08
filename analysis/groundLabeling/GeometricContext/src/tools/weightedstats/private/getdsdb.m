function thedsdb=getdsdb(varargin)

%   $Revision: 1.1 $  $Date: 2012/09/25 15:40:56 $
%   Copyright 2003-2004 The MathWorks, Inc.

thedsdb = dfgetset('thedsdb');

% Create a singleton class instance
if isempty(thedsdb)
   thedsdb = stats.dsdb;
   dfgetset('thedsdb',thedsdb);
end


