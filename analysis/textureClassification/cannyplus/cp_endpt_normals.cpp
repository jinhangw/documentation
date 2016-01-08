#include "mex.h"
#include "math.h"
#include "string.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  
    /* variables */
    int R,C;
    double *visited, *visited2;
    unsigned int idx, idx_pixel;        
    int cur_i, cur_j;
    int v_i, v_j;       /* used for counting length of segment */
    bool isend = false;
    unsigned int edgeid;
    
    /* input */
    double *edgemap_edgeid;
    double *normals;
    double *param1;
    unsigned int num_edges;
    
    /* output */
    double *en1, *en2;  // endpoint normals [x,y,normal]
            
    /* get the number of rows and columns of edgemap */
    R = mxGetM(prhs[0]);
    C = mxGetN(prhs[0]);
    
    /* get input data */
    edgemap_edgeid = mxGetPr(prhs[0]);
    normals = mxGetPr(prhs[1]);
    param1 = mxGetPr(prhs[2]); num_edges = (unsigned int) param1[0];
    
    
    /* allocate output */
    plhs[0] = mxCreateDoubleMatrix(num_edges,3,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(num_edges,3,mxREAL);
    en1 = mxGetPr(plhs[0]);
    en2 = mxGetPr(plhs[1]);
           
    /* initialize variables */
    for (int i = 0; i < num_edges; i++) {
        for (int j = 0; j < 3; j++) {
            en1[i+j*num_edges] = 0;
            en2[i+j*num_edges] = 0;
        }
    }
    
    /* keep track of which pixels have been visited */
    visited = (double *) mxMalloc((R*C) * sizeof(double));
    visited2 = (double *) mxMalloc((R*C) * sizeof(double));
    
    /* initialize variables */
    for (int i = 0; i < R; i++) {
        for (int j = 0; j < C; j++) {
            visited[i+j*R] = 0;
            visited2[i+j*R] = 0;
        }
    }
    
    
    /* rastor scan the pixels */
    for (int i = 1; i < (R-1); i++) {        
        for (int j = 1; j < (C-1); j++) {            
            cur_i = i;
            cur_j = j;            
            idx_pixel = i + j*R;
            /* check to see if this pixel is part of an edge and if it has been visited */            
            if ((edgemap_edgeid[idx_pixel] != 0) && (visited2[idx_pixel] == 0)) {                
                edgeid = (unsigned int) edgemap_edgeid[idx_pixel];
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
                        
                            if ((visited[idx] == 0) && (edgemap_edgeid[idx] != 0)) {
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
                
                /* walk through the whole segment the other way */                
                isend = false;
                v_i = cur_i;
                v_j = cur_j;
                visited2[v_i+v_j*R] = 1;
                en1[(edgeid-1)+0*num_edges] = v_j+1;
                en1[(edgeid-1)+1*num_edges] = v_i+1;
                en1[(edgeid-1)+2*num_edges] = normals[v_i+v_j*R];
                while (!isend) {                    
                    isend = true;                    
                    for (int k = -1; k <= 1; k++) {
                        for (int l = -1; l <= 1; l++) {                            
                            if ((k==0) && (l == 0)) {
                                /* center pixel */
                                continue;
                            }
                            idx = (v_i+k) + (v_j+l)*R;
                            if ((visited2[idx] == 0) && (edgemap_edgeid[idx] != 0)) {
                                /* update idx */
                                visited2[idx] = 1;
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
                en2[(edgeid-1)+0*num_edges] = v_j+1;
                en2[(edgeid-1)+1*num_edges] = v_i+1;
                en2[(edgeid-1)+2*num_edges] = normals[v_i+v_j*R];
                
                
                
            }
        }
    }
        
}
