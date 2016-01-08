function [name, distname, dataset, exrule, results] = dfgetupdateinfo(fit)
%DFGETUPDATEINFO GUI helper to delete an exclusion rule

%   $Revision: 1.1 $  $Date: 2012/09/25 15:40:39 $
%   Copyright 2003-2004 The MathWorks, Inc.

name = fit.name;
fittype = fit.fittype;
      
if strcmp(fittype, 'smooth')
    distname = 'nonparametric';
else %parametric
    distname = fit.distname;
end

dataset = fit.dataset;
exrule = fit.exclusionrulename;
results = fit.resultstext;
    







