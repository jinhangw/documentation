#include "mex.h"
#include "math.h"
#include "string.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  
    /* input */
    double *edgemap;
    double *edgemap_allptid;
    double *valid_allptid;
    
    /* output */
    double *vedgemap;
    
    /* other variables */
    double *visited, *visited2;
    unsigned int idx, idx_pixel;
    unsigned int prev1_idx, prev2_idx;
    unsigned int edgelen;
    unsigned int maxlen = 0;
    unsigned int eapid;
    
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
    
    /* load the data */    
    edgemap = mxGetPr(prhs[0]);
    edgemap_allptid = mxGetPr(prhs[1]);
    valid_allptid = mxGetPr(prhs[2]);
    
    /* create mxArray for output data */
    plhs[0] = mxCreateDoubleMatrix(R,C,mxREAL);
    vedgemap = mxGetPr(plhs[0]);
    
    /* keep track of which pixels have been visited */
    visited = (double *) mxMalloc((R*C) * sizeof(double));
    visited2 = (double *) mxMalloc((R*C) * sizeof(double));
    
    /* initialize variables */
    for (int i = 0; i < R; i++) {
        for (int j = 0; j < C; j++) {
            vedgemap[i+j*R] = 0;            
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
            
            if ((edgemap[idx_pixel] != 0) && (visited2[idx_pixel] == 0)) {                
                
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
                
                /* remove any pts that are not valid */
                isend = false;
                v_i = cur_i;
                v_j = cur_j;
                visited2[v_i+v_j*R] = 1;
                eapid = (unsigned int) edgemap_allptid[v_i+v_j*R];
                if(valid_allptid[eapid] == 1) {
                    vedgemap[v_i+v_j*R] = 1;
                }
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
                                v_i = v_i + k;
                                v_j = v_j + l;
                                eapid = (unsigned int) edgemap_allptid[v_i+v_j*R];
                                if(valid_allptid[eapid] == 1) {
                                    vedgemap[v_i+v_j*R] = 1;
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
            }            
        }
    }
            
}
