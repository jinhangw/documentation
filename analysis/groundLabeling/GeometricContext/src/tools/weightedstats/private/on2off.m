function a = on2off(b)
%ON2OFF Simple helper returns 'on' given 'off' and vice versa

%   $Revision: 1.1 $  $Date: 2012/09/25 15:41:01 $
%   Copyright 2003-2004 The MathWorks, Inc.

if isequal(b,'on')
   a = 'off';
else
   a = 'on';
end
