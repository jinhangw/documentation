% compile all mex files

mex cp_compute_adjacency.cpp -largeArrayDims
mex cp_connect_edges.cpp
mex cp_endpt_normals.cpp
mex cp_edgelist.cpp
mex cp_removejunctions.cpp
mex cp_rm_invalid_edgepts.cpp
mex cp_breakcorners.cpp