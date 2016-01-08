function [new, fittype]=dfcreatecopy(original);

%   $Revision: 1.1 $  $Date: 2012/09/25 15:40:36 $
%   Copyright 2003-2004 The MathWorks, Inc.

fittype = original.fittype;

new = copyfit(original);
new = java(new);

