function [edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(img, mask)
% CANNYPLUS - Edge detector which postprocesses the canny edge detector by
%   removing segments that are too short and not smooth enough using
%   spectral graph clustering
%
%   Usage: [edgemap, edgemap_edgeid, edgemap_ptid] = cannyplus(img);
%
%   Input:
%       img - a color or grayscale image
%       mask (optional) - RxC mask or specify as bbox - [cx,cy,w,h]
%
%   Output:
%       edgemap - RxC, binary edgemap
%       edgemap_edgeid - RxC, labels each edge with a unique id
%       edgemap_ptid - RxC, labels the points on each edge from 1 to
%                     length of the edge
%       edgenormals - RxC - edgenormals at each point
%
% Edward Hsiao
% ehsiao@cs.cmu.edu


% Check if image is grayscale or color
if size(img,3) == 3,
    img = rgb2gray(img);
  %   img=RGB2Lab(img);
   %  img=uint8(img(:,:,1));
end

img = histeq(img(:,:,1));


% Check if image is double or not
if ~isa(img, 'double'),
    img = im2double(img);
end




% parameters
canny_low = 0.05;
canny_high = 0.12;
canny_sigma = 1;
minlen = 3;             % initial minimum length
minlen2=6;

gapsize = 5;            % gap to bridge
num_iter_powermethod = 500;      % iterations for power method
th_delta = 1e-6;                 % change in average squared distance
ratio_maxlen = 0.03;             % ratio of longest segment for min length
ratio_maxeig = 0.6;              % ratio of maximum eigenvalue for min eig
th_dnormal = pi/4;               % maximum change in normal allowed on smooth curve

% canny edge detector
edgemap = double(edge(img,'canny',[canny_low,canny_high],canny_sigma));

% filter edges outside bounding box
if nargin > 1
    % determine if mask or bbox
    if length(mask) == 4    % [cx,cy,w,h]
        bbox = mask;
        cx = bbox(1); cy = bbox(2); w = bbox(3); h = bbox(4);
        x1 = round(cx - w/2); x2 = round(cx + w/2); y1 = round(cy - h/2); y2 = round(cy + h/2);
        mask = false(size(edgemap));
        mask(y1:y2,x1:x2) = true;
    end
    edgemap = double(edgemap&mask);
end


% remove junctions from edges first
%edgemap = cp_removejunctions(edgemap);

% break the corners twice (recalculate normals in between)
[edgemap,edgemap_edgeid,edgemap_ptid, edgenormals, num_edges] = cp_edgelist(edgemap, minlen2);
edgemap = cp_breakcorners(edgemap, edgenormals, th_dnormal);
% [edgemap,edgemap_edgeid,edgemap_ptid, edgenormals, num_edges] = cp_edgelist(edgemap, minlen);
% edgemap = cp_breakcorners(edgemap, edgenormals, th_dnormal);

% recompute edge list
[edgemap,edgemap_edgeid,edgemap_ptid, edgenormals, num_edges] = cp_edgelist(edgemap, minlen);

% find endpoint normals
[en1,en2] = cp_endpt_normals(edgemap_edgeid, edgenormals, num_edges);

% connect edges
edgemap = cp_connect_edges(edgemap, en1, en2, gapsize);

% remove junctions from edges
%edgemap = cp_removejunctions(edgemap);

% renumber the edges
[edgemap,edgemap_edgeid,edgemap_ptid, edgenormals, num_edges, edgemap_allptid, num_edgepts, maxlen] = cp_edgelist(edgemap, minlen2);


%minlen = ceil(maxlen * ratio_maxlen);
% % compute sparse adjacency matrix
% A = cp_compute_adjacency(edgemap_edgeid,edgemap_ptid,edgemap_allptid,edgenormals,num_edgepts);
% 
% % start with vector of all ones
% v = ones(num_edgepts,1);
% prev_v = zeros(num_edgepts,1);
% % iterate
% for i = 1:num_iter_powermethod
%     v = A*v;
%     maxv = max(abs(v));
%     v = v / maxv; 
%     delta = sum((prev_v-v).^2) / num_edgepts;
%     if delta < th_delta
%         break;
%     end
%     prev_v = v;
% end
% ev = A*v ./ v;
% valid = double(ev >= max(ev) * ratio_maxeig);
% 
% % remove invalid edges
% [edgemap] = cp_rm_invalid_edgepts(edgemap, edgemap_allptid, valid);
% 
% % remove junctions from edges
% edgemap = cp_removejunctions(edgemap);
% 
% % renumber the edges
% [edgemap,edgemap_edgeid,edgemap_ptid,edgenormals] = cp_edgelist(edgemap, minlen);
