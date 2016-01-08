#include "mex.h"
#include "string.h"
#include "math.h"

#define PI 3.14159265358979323846

double normaldiff(double n1, double n2) {
    double nd,nd2;
    nd = fabs(n1-n2);
    nd2 = fabs(PI + n1 - n2);
    if (nd2 < nd) {
        nd = nd2;
    }
    nd2 = fabs(PI + n2 - n1);
    if (nd2 < nd) {
        nd = nd2;
    }
    return nd;   
}

void connectedge(double* cedgemap, double x1, double y1, double x2, double y2, int R) {
    /* fill in missing pixels between (x1,y1) and (x2,y2) to connect the edge */
    int i1 = (int) (y1)-1;
    int j1 = (int) (x1)-1;
    int i2 = (int) (y2)-1;
    int j2 = (int) (x2)-1;

//     mexPrintf("(%d,%d) -> (%d,%d)\n",i1,j1,i2,j2);
    int k, l;
    int bestk, bestl;
    double bestd, d;
    bestd = sqrt(pow((double)(i1-i2),2) + pow((double)(j1-j2),2));
    /* walk from (i1,j1) to (i2,j2) */
    while ((i1 != i2) || (j1 != j2)) {
        bestk = 0;
        bestl = 0;
        for (k = -1; k <= 1; k++) {
            for (l = -1; l <= 1; l++) {
                d = sqrt(pow((double)(i1+k-i2),2) + pow((double)(j1+l-j2),2));
                if (d < bestd) {
                    bestd = d;
                    bestk = k;
                    bestl = l;
                }
            }            
        }   
        /* move to new position and mark it as an edge */
        i1 = i1 + bestk;
        j1 = j1 + bestl;
        cedgemap[i1+j1*R] = 1;
    }
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  
    /* variables */
    int R,C;
    bool *used1, *used2;
    unsigned int num_edges;
    double d;
    double x1,y1,x2,y2;
    double n1,n2;
    double v12;
    
    /* input */
    double *edgemap;
    double *en1, *en2;  // endpoint normals [x,y,normal]
    double *param1;
    double gapsize;
    
    /* output */
    double *cedgemap;
            
    /* get the number of rows and columns of edgemap */
    R = mxGetM(prhs[0]);
    C = mxGetN(prhs[0]);
    num_edges = mxGetM(prhs[1]);
    
    /* get input data */
    edgemap = mxGetPr(prhs[0]);
    en1 = mxGetPr(prhs[1]);
    en2 = mxGetPr(prhs[2]);
    param1 = mxGetPr(prhs[3]); gapsize = param1[0];
    
    
    /* allocate output */
    plhs[0] = mxCreateDoubleMatrix(R,C,mxREAL);
    cedgemap = mxGetPr(plhs[0]);
           
    /* initialize variables, a copy of edgemap */
    for (int i = 0; i < R; i++) {
        for (int j = 0; j < C; j++) {
            cedgemap[i+j*R] = edgemap[i+j*R];
        }
    }
    
       
    /* indicator if edge endpoint has been connected */
    used1 = (bool *) mxMalloc(num_edges * sizeof(bool));
    used2 = (bool *) mxMalloc(num_edges * sizeof(bool));
    for (int i = 0; i < num_edges; i++) {
        used1[i] = false;
        used2[i] = false;
    }
    
    
    
    for (int i = 0; i < num_edges; i++) {
        for (int j = i+1; j < num_edges; j++) {
            /* initialize all distances so they won't satisfy gap thresh */        
            /* compute distances for points that have not been used */
//             if ((i == 38) && (j == 39)) {
//                 mexPrintf("Inside\n");
//             }
            if (!used1[i] && !used1[j]) {    
                x1 = en1[i+0*num_edges];
                y1 = en1[i+1*num_edges];
                n1 = en1[i+2*num_edges];
                x2 = en1[j+0*num_edges];
                y2 = en1[j+1*num_edges];
                n2 = en1[j+2*num_edges];
                v12 = atan2(y2-y1,x2-x1);
                d = sqrt(pow(x2-x1,2) + pow(y2-y1,2));
//                 if ((i == 38) && (j == 39)) {
//                      mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f, n1 = %0.2f, n2 = %0.2f, v12 = %0.2f, %0.2f, %0.2f, %0.2f\n",x1,y1,x2,y2,d,n1,n2,v12,normaldiff(n1,n2),fabs(PI/2 - normaldiff(n1,v12)),fabs(PI/2 - normaldiff(n2,v12))); 
//                 }
//                 mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f\n",x1,y1,x2,y2,d);
//                 if (d < gapsize) {
                if ((d < gapsize) && (normaldiff(n1,n2) < PI/6) && (fabs(PI/2 - normaldiff(n1,v12)) < PI/6) && (fabs(PI/2 - normaldiff(n2,v12)) < PI/6)) {
//                     mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f, n1 = %0.2f, n2 = %0.2f, v12 = %0.2f\n",x1,y1,x2,y2,d,n1,n2,v12); 
                    connectedge(cedgemap,x1,y1,x2,y2,R);
                    used1[i] = true;
                    used1[j] = true;
                    continue;                                    
                }
                
            }
            
            if (!used1[i] && !used2[j]) {    
                x1 = en1[i+0*num_edges];
                y1 = en1[i+1*num_edges];
                n1 = en1[i+2*num_edges];
                x2 = en2[j+0*num_edges];
                y2 = en2[j+1*num_edges];
                n2 = en2[j+2*num_edges];
                v12 = atan2(y2-y1,x2-x1);
                d = sqrt(pow(x2-x1,2) + pow(y2-y1,2));
//                 if ((i == 38) && (j == 39)) {
//                     mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f, n1 = %0.2f, n2 = %0.2f, v12 = %0.2f, %0.2f, %0.2f, %0.2f\n",x1,y1,x2,y2,d,n1,n2,v12,normaldiff(n1,n2),fabs(PI/2 - normaldiff(n1,v12)),fabs(PI/2 - normaldiff(n2,v12))); 
//                 }
//                 mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f\n",x1,y1,x2,y2,d);                
//                 if (d < gapsize) {
                if ((d < gapsize) && (normaldiff(n1,n2) < PI/6) && (fabs(PI/2 - normaldiff(n1,v12)) < PI/6) && (fabs(PI/2 - normaldiff(n2,v12)) < PI/6)) {
//                     mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f, n1 = %0.2f, n2 = %0.2f, v12 = %0.2f\n",x1,y1,x2,y2,d,n1,n2,v12); 
                    connectedge(cedgemap,x1,y1,x2,y2,R);
                    used1[i] = true;
                    used2[j] = true;
                    continue;   
                }             
            }

            if (!used2[i] && !used1[j]) {    
                x1 = en2[i+0*num_edges];
                y1 = en2[i+1*num_edges];
                n1 = en2[i+2*num_edges];
                x2 = en1[j+0*num_edges];
                y2 = en1[j+1*num_edges];
                n2 = en1[j+2*num_edges];
                v12 = atan2(y2-y1,x2-x1);
                d = sqrt(pow(x2-x1,2) + pow(y2-y1,2));        
//                 if ((i == 38) && (j == 39)) {
//                      mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f, n1 = %0.2f, n2 = %0.2f, v12 = %0.2f, %0.2f, %0.2f, %0.2f\n",x1,y1,x2,y2,d,n1,n2,v12,normaldiff(n1,n2),fabs(PI/2 - normaldiff(n1,v12)),fabs(PI/2 - normaldiff(n2,v12))); 
//                 }
//                 if (d < gapsize) {
                if ((d < gapsize) && (normaldiff(n1,n2) < PI/6) && (fabs(PI/2 - normaldiff(n1,v12)) < PI/6) && (fabs(PI/2 - normaldiff(n2,v12)) < PI/6)) {
//                     mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f, n1 = %0.2f, n2 = %0.2f, v12 = %0.2f\n",x1,y1,x2,y2,d,n1,n2,v12); 
                    connectedge(cedgemap,x1,y1,x2,y2,R);                    
                    used2[i] = true;
                    used1[j] = true;
                    continue;   
                }
             
            }

            if (!used2[i] && !used2[j]) {    
                x1 = en2[i+0*num_edges];
                y1 = en2[i+1*num_edges];
                n1 = en2[i+2*num_edges];
                x2 = en2[j+0*num_edges];
                y2 = en2[j+1*num_edges];
                n2 = en2[j+2*num_edges];
                v12 = atan2(y2-y1,x2-x1);
                d = sqrt(pow(x2-x1,2) + pow(y2-y1,2));      
//                 if ((i == 38) && (j == 39)) {
//                      mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f, n1 = %0.2f, n2 = %0.2f, v12 = %0.2f, %0.2f, %0.2f, %0.2f\n",x1,y1,x2,y2,d,n1,n2,v12,normaldiff(n1,n2),fabs(PI/2 - normaldiff(n1,v12)),fabs(PI/2 - normaldiff(n2,v12))); 
//                 }
//                 if (d < gapsize) {
                if ((d < gapsize) && (normaldiff(n1,n2) < PI/6) && (fabs(PI/2 - normaldiff(n1,v12)) < PI/6) && (fabs(PI/2 - normaldiff(n2,v12)) < PI/6)) {
//                     mexPrintf("(%0.1f, %0.1f) -> (%0.1f ,%0.1f), d = %0.2f, n1 = %0.2f, n2 = %0.2f, v12 = %0.2f\n",x1,y1,x2,y2,d,n1,n2,v12);  
                    connectedge(cedgemap,x1,y1,x2,y2,R);
                    used2[i] = true;
                    used2[j] = true;
                    continue;                       
                }             
            }
            
            
        }
    }
        
}
