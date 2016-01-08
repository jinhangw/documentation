function hExcl = dfgetexclusionrule(ename)
%GETEXCLUSIONRULE Get an exclusion rule by name

% $Revision: 1.1 $  $Date: 2012/09/25 15:40:38 $
% Copyright 2003-2004 The MathWorks, Inc.

db = getoutlierdb;
hExcl = find(db,'name',ename);

