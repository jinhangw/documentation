function name = dfgetfitname()

% $Revision: 1.1 $  $Date: 2012/09/25 15:40:38 $
% Copyright 2003-2004 The MathWorks, Inc.

count=dfgetset('fitcount');
if isempty(count)
    count = 1;
end
taken = 1;
while taken
    name=sprintf('fit %i', count);
    if isempty(find(getfitdb,'name',name))
        taken = 0;
    else
        count=count+1;
    end
end
dfgetset('fitcount',count+1);

