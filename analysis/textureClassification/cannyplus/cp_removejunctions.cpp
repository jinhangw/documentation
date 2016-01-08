#include "mex.h"
#include "math.h"
#include "string.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  
    double *edgemap;
    double *edgemapnj;
    int R,C;
    unsigned int idx;
    double sum;
    
    double remainingbins;
    double neededbins;    
    
    /* get the number of rows and columns of edgemap */
    R = mxGetM(prhs[0]);
    C = mxGetN(prhs[0]);
    
    /* load the data */    
    edgemap = mxGetPr(prhs[0]);
    
    /* create mxArray for output data */
    plhs[0] = mxCreateDoubleMatrix(R,C,mxREAL);
    edgemapnj = mxGetPr(plhs[0]);
    
    for (int i = 1; i < R; i++) {
        for (int j = 1; j < C; j++) {
            /* check to see if this pixel is part of an edge */
            if (edgemap[i + j*R] != 0) {
                sum = 0;
                /* sum the 3x3 neighborhood */
                for (int k = -1; k <= 1; k++) {
                    for (int l = -1; l <= 1; l++) {
                         sum = sum + edgemap[(i+k) + (j+l)*R];
                    }
                }
                /* junction point if sum is more than 3, otherwise add to output */
                if (sum <= 3) {
                    edgemapnj[i + j*R] = 1;
                }
            }            
        }
    }
        
}
