function ok = dfasksavesession(dffig)
%DFASKSAVESESSION Ask whether current session should be saved

%   $Revision: 1.1 $  $Date: 2012/09/25 15:40:35 $
%   Copyright 2003-2004 The MathWorks, Inc.

dsdb = getdsdb;
fitdb = getfitdb;

% Offer to save session unless there's nothing to save
if isempty(down(dsdb)) && isempty(down(fitdb))
   resp = 'No';
else
   resp = questdlg('Save this Distribution Fitting session?', ...
                   'Distribution Fitting', 'Yes', 'No', 'Cancel', 'Yes');
end

if isempty(resp)
	resp = 'Cancel';
end

if isequal(resp,'Yes')
   ok = dfsession('save');
   if ~ok
      resp = 'Cancel';
   end
end

ok = ~isequal(resp,'Cancel');
