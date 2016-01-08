#include "mex.h"
#include "math.h"
#include "string.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  
    /* input */
    double *edgemap;
    double *param1;
    unsigned int minlen;  

    
    /* output */
    double *newedgemap;
    double *edgemap_edgeid;
    double *edgemap_ptid;
    double *normals;
    double *num_edges;
    double *edgemap_allptid;
    double *num_edgepts;
    double *edge_maxlen;
    
    /* other variables */
    double *visited, *visited2;
    unsigned int idx, idx_pixel;
    unsigned int prev1_idx, prev2_idx;
    unsigned int edgelen;
    unsigned int maxlen = 0;
    
    
    int cur_i, cur_j;
    int v_i, v_j;       /* used for counting length of segment */
    int prev1_v_i, prev1_v_j;
    int prev2_v_i, prev2_v_j;    
    int R,C;
    double edgeid = 1;
    double ptid;
    double allptid;
    bool isend = false;
    bool foundnext = false;
    
    double remainingbins;
    double neededbins;    
    
    /* get the number of rows and columns of edgemap */
    R = mxGetM(prhs[0]);
    C = mxGetN(prhs[0]);
    param1 = mxGetPr(prhs[1]);  minlen = (unsigned int)param1[0];
    
    /* load the data */    
    edgemap = mxGetPr(prhs[0]);
    
    /* create mxArray for output data */
    plhs[0] = mxCreateDoubleMatrix(R,C,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(R,C,mxREAL);
    plhs[2] = mxCreateDoubleMatrix(R,C,mxREAL);           
    plhs[3] = mxCreateDoubleMatrix(R,C,mxREAL);
    plhs[4] = mxCreateDoubleMatrix(1,1,mxREAL);
    plhs[5] = mxCreateDoubleMatrix(R,C,mxREAL);
    plhs[6] = mxCreateDoubleMatrix(1,1,mxREAL);
    plhs[7] = mxCreateDoubleMatrix(1,1,mxREAL);
    newedgemap = mxGetPr(plhs[0]);
    edgemap_edgeid = mxGetPr(plhs[1]);
    edgemap_ptid = mxGetPr(plhs[2]);
    normals = mxGetPr(plhs[3]);
    num_edges = mxGetPr(plhs[4]);
    edgemap_allptid = mxGetPr(plhs[5]);
    num_edgepts = mxGetPr(plhs[6]);
    edge_maxlen = mxGetPr(plhs[7]);
    
    /* keep track of which pixels have been visited */
    visited = (double *) mxMalloc((R*C) * sizeof(double));
    visited2 = (double *) mxMalloc((R*C) * sizeof(double));
    
    /* initialize variables */
    for (int i = 0; i < R; i++) {
        for (int j = 0; j < C; j++) {
            newedgemap[i+j*R] = 0;
            edgemap_edgeid[i+j*R] = 0;
            edgemap_ptid[i+j*R] = 0;
            edgemap_allptid[i+j*R] = 0;
            normals[i+j*R] = 0;
            visited[i+j*R] = 0;
            visited2[i+j*R] = 0;
        }
    }
    
    allptid = 0;
    /* rastor scan the pixels */
    for (int i = 1; i < (R-1); i++) {        
        for (int j = 1; j < (C-1); j++) {            
            cur_i = i;
            cur_j = j;            
            idx_pixel = i + j*R;
            /* check to see if this pixel is part of an edge */
            
            if ((edgemap[idx_pixel] != 0) && (edgemap_edgeid[idx_pixel] == 0)) {                
                
                visited[idx_pixel] = 1;                
                /* walk until one end of the segment */
                isend = false;
                while (!isend) {                    
                    isend = true;                    
                    for (int k = -1; k <= 1; k++) {
                        for (int l = -1; l <= 1; l++) {                            
                            if ((k==0) && (l == 0)) {
                                /* center pixel */
                                continue;                            }
                            idx = (cur_i+k) + (cur_j+l)*R;
                            
                            
                            if ((visited[idx] == 0) && (edgemap[idx] != 0)) {
                                /* update idx */
                                visited[idx] = 1;
                                cur_i = cur_i + k;
                                cur_j = cur_j + l;
                                isend = false;
                                break;
                            }
                        }
                        if (isend == false){
                            break;                            
                        }
                    }
                }                
                
                
                /* remove any segments that are too short */
                isend = false;
                v_i = cur_i;
                v_j = cur_j;
                edgelen = 1;
                visited2[v_i+v_j*R] = 1;
                while (!isend) {                    
                    isend = true;                    
                    for (int k = -1; k <= 1; k++) {
                        for (int l = -1; l <= 1; l++) {                            
                            if ((k==0) && (l == 0)) {
                                /* center pixel */
                                continue;
                            }
                            idx = (v_i+k) + (v_j+l)*R;
                            if ((visited2[idx] == 0) && (edgemap[idx] != 0)) {
                                /* update idx */
                                visited[idx] = 1;
                                visited2[idx] = 1;
                                v_i = v_i + k;
                                v_j = v_j + l;
                                edgelen++;
                                isend = false;
                                break;
                            }
                        }
                        if (isend == false){
                            break;
                        }
                    }
                    /* early exit once we know edgelen is long enough */                    
//                     if (edgelen >= minlen) {
//                         break;
//                     }
                }
                
                if (edgelen >= maxlen) {
                    maxlen = edgelen;
                }
                   
                /* if segment is long enough, now walk the other way, labeling the edge */
                if (edgelen >= minlen) {
                    
                    /* label the edgeid and ptids along the edge */
                    isend = false;
                    ptid = 1;
                    v_i = cur_i;
                    v_j = cur_j;
                    edgemap_edgeid[v_i+v_j*R] = edgeid;
                    edgemap_ptid[v_i+v_j*R] = 1;
                    
                    allptid++;
                    edgemap_allptid[v_i+v_j*R] = allptid;
                    
                    newedgemap[v_i+v_j*R] = 1;
                    while (!isend) {                    
                        isend = true;                    
                        for (int k = -1; k <= 1; k++) {
                            for (int l = -1; l <= 1; l++) {                            
                                if ((k==0) && (l == 0)) {
                                    /* center pixel */
                                    continue;
                                }
                                idx = (v_i+k) + (v_j+l)*R;
                                if ((edgemap_edgeid[idx] == 0) && (edgemap[idx] != 0)) {
                                    /* update idx */
                                    visited[idx] = 1;
                                    visited2[idx] = 1;
                                    edgemap_edgeid[idx] = edgeid;
                                    newedgemap[idx] = 1;
                                    ptid++;
                                    edgemap_ptid[idx] = ptid;
                                    allptid++;
                                    edgemap_allptid[idx] = allptid;
                                    
                                    v_i = v_i + k;
                                    v_j = v_j + l;

                                    isend = false;
                                    break;
                                }
                            }
                            if (isend == false){
                                break;
                            }
                        }
                    }

                    /* go through again and compute the normals */
                    isend = false;
                    ptid = 1;
                    v_i = cur_i;
                    v_j = cur_j;                    
                    
                    while (!isend) {                    
                        isend = true;                    
                        for (int k = -1; k <= 1; k++) {
                            for (int l = -1; l <= 1; l++) {                            
                                if ((k==0) && (l == 0)) {
                                    /* center pixel */
                                    continue;
                                }
                                idx = (v_i+k) + (v_j+l)*R;
                                if ((edgemap_ptid[idx] == ptid+1) && (edgemap[idx] != 0)) {                                                                                                          
                                    /* update idx */                                    
                                    ptid++;
                                    
                                    if (ptid == 2) {
                                        prev2_v_i = v_i;
                                        prev2_v_j = v_j;
                                        v_i = v_i + k;
                                        v_j = v_j + l;                                        
                                    }
                                    else if (ptid == 3) {
                                        prev1_v_i = v_i;
                                        prev1_v_j = v_j;
                                        v_i = v_i + k;
                                        v_j = v_j + l;
                                        
                                        prev1_idx = prev1_v_i + prev1_v_j*R;
                                        prev2_idx = prev2_v_i + prev2_v_j*R;
                                        
                                        normals[prev1_idx] = atan2((double) -(v_j-prev2_v_j), (double) (v_i-prev2_v_i));
                                        normals[prev2_idx] = normals[prev1_idx];
                                    }
                                    else {
                                        prev2_v_i = prev1_v_i;
                                        prev2_v_j = prev1_v_j;
                                        prev1_v_i = v_i;
                                        prev1_v_j = v_j;
                                        v_i = v_i + k;
                                        v_j = v_j + l;                          
                                        
                                        prev1_idx = prev1_v_i + prev1_v_j*R;
                                        
                                        
                                        normals[prev1_idx] = atan2((double) -(v_j-prev2_v_j), (double) (v_i-prev2_v_i));
                                        
                                    }

                                    isend = false;
                                    break;
                                }
                            }
                            if (isend == false){
                                break;
                            }
                        }
                    }
                    /* normal for the endpoint */
                    normals[v_i+v_j*R] = normals[prev1_idx];
                    
                    
                    edgeid++;
                }
                
                
                
                
                
                
            }            
        }
    }
    
    /* output the number of edges */
    num_edges[0] = edgeid - 1;
    num_edgepts[0] = allptid;
    edge_maxlen[0] = maxlen;
        
}
