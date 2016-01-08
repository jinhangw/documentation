#include "mex.h"
#include "math.h"
#include "string.h"

#define PI 3.14159265358979323846

double anglediff(double a1, double a2) {
    double dangle;
    double tmpd;
    dangle = a2-a1;
    tmpd = a2 - a1 - 2*PI;
    if(fabs(tmpd) < fabs(dangle)) {
        dangle = tmpd;
    }
    tmpd = a2 - a1 + 2*PI;
    if(fabs(tmpd) < fabs(dangle)) {
        dangle = tmpd;
    }
    
    return fabs(dangle);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  
    /* input */
    double *edgemap;
    double *normals; 
    double *param1;
    double th;

    /* output */
    double *newedgemap;
    
    /* other variables */
    double *visited, *visited2;
    unsigned int idx, idx_pixel;
    unsigned int prev1_idx, prev2_idx;
    
    double ndiff;
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
    double *edgemap_edgeid;
    
    /* get the number of rows and columns of edgemap */
    R = mxGetM(prhs[0]);
    C = mxGetN(prhs[0]);
    
    /* load the data */    
    edgemap = mxGetPr(prhs[0]);
    normals = mxGetPr(prhs[1]);
    param1 = mxGetPr(prhs[2]);
    th = param1[0];
    
    /* create mxArray for output data */
    plhs[0] = mxCreateDoubleMatrix(R,C,mxREAL);
    newedgemap = mxGetPr(plhs[0]);
    
    /* keep track of which pixels have been visited */
    edgemap_edgeid = (double *) mxMalloc((R*C) * sizeof(double));
    visited = (double *) mxMalloc((R*C) * sizeof(double));
    visited2 = (double *) mxMalloc((R*C) * sizeof(double));
    
    /* initialize variables */
    for (int i = 0; i < R; i++) {
        for (int j = 0; j < C; j++) {
            newedgemap[i+j*R] = edgemap[i+j*R];
            edgemap_edgeid[i+j*R] = 0;
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
                                
                /* remove any pixels where it is possibly a corner */
                isend = false;
                v_i = cur_i;
                v_j = cur_j;
                ptid = 1;
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
                                visited2[idx] = 1;
                                
                                if (ptid == 1) {
                                    prev1_v_i = v_i;
                                    prev1_v_j = v_j;
                                    v_i = v_i + k;
                                    v_j = v_j + l;
                                }
                                else {
                                    prev2_v_i = prev1_v_i;
                                    prev2_v_j = prev1_v_j;
                                    prev1_v_i = v_i;
                                    prev1_v_i = v_i;
                                    prev1_v_j = v_j;
                                    v_i = v_i + k;
                                    v_j = v_j + l;  
                                    
                                    prev1_idx = prev1_v_i + prev1_v_j*R;
                                    prev2_idx = prev2_v_i + prev2_v_j*R;
                                    
                                    // break edge if angle diff is too large
                                    ndiff = anglediff(normals[idx],normals[prev2_idx]);                                    
                                    if (ndiff >= th)
                                        newedgemap[prev1_idx] = 0;
                                        
                                }
                                ptid++;
                                
                                isend = false;
                                break;
                            }
                        }
                        if (isend == false){
                            break;
                        }
                    }
                }
                
            }            
        }
    }
    
    mxFree(edgemap_edgeid);
    mxFree(visited);
    mxFree(visited2);
        
}
