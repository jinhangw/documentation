function [varargout]=statinsertnan(wasnan,varargin)
%STATINSERTNAN Insert NaN values into inputs where they were removed

%   Copyright 1993-2002 The MathWorks, Inc. 
%   $Revision: 1.1 $  $Date: 2012/09/25 15:41:05 $

nanvec = zeros(size(wasnan))*NaN;
ok = ~wasnan;

% Find NaN, check length, and store outputs temporarily
for j=1:nargin-1
   y = varargin{j};
   if (size(y,1)==1), y =  y'; end

   [n p] = size(y);
   if (p==1)
      x = nanvec;
   else
      x = repmat(nanvec,1,p);
   end
   x(ok,:) = y;
   varargout{j} = x;
end
