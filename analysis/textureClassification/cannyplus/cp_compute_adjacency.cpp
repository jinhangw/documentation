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


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  
    /* variables */
    int R,C;
    unsigned int num_edgepts;
    double d;
    double x1,y1,x2,y2;
    double n1,n2;
    double v12;
    unsigned int edgelen;
    double *adjacency;
    double *visited, *visited2, *visited3;
    unsigned int idx, idx_pixel, idx_adj1, idx_adj2;        
    int cur_i, cur_j;
    int v_i, v_j;       /* used for counting length of segment */
    unsigned int center_ptid, other_ptid;
    bool isend = false;
    double adjscore;
    unsigned int edgeid;
    unsigned int minptid;
    unsigned int spidx = 0;
    int l,k;
    
    /* sparse matrix */
    mwIndex *ir, *jc;
    int nzmax,cmplx,isfull;
    double *pr;

    
    /* input */
    double *edgemap_edgeid;
    double *edgemap_ptid;
    double *edgemap_allptid;
    double *normals;
    double *param1;
    
    /* output */
                
    /* get the number of rows and columns of edgemap */
    R = mxGetM(prhs[0]);
    C = mxGetN(prhs[0]);
    
    /* get input data */
    edgemap_edgeid = mxGetPr(prhs[0]);
    edgemap_ptid = mxGetPr(prhs[1]);
    edgemap_allptid = mxGetPr(prhs[2]);
    normals = mxGetPr(prhs[3]);
    param1 = mxGetPr(prhs[4]); num_edgepts = (unsigned int) param1[0];
    
    /* allocate output */
    nzmax = (int)ceil((double)num_edgepts * 11);  /* assume 11 entries per row */
    plhs[0] = mxCreateSparse(num_edgepts,num_edgepts,nzmax,mxREAL);
    pr = mxGetPr(plhs[0]);
    ir = mxGetIr(plhs[0]);
    jc = mxGetJc(plhs[0]);            


/* keep track of which pixels have been visited */
    visited = (double *) mxMalloc((R*C) * sizeof(double));
    visited2 = (double *) mxMalloc((R*C) * sizeof(double));
    visited3 = (double *) mxMalloc((R*C) * sizeof(double));
    
    /* initialize variables */
    for (int i = 0; i < R; i++) {
        for (int j = 0; j < C; j++) {
            visited[i+j*R] = 0;
            visited2[i+j*R] = 0;
            visited3[i+j*R] = 0;
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
//                 mexPrintf("Edgeid: %d\n ", edgeid);
                visited[idx_pixel] = 1;                
                /* walk until one end of the segment */
                isend = false;
                while (!isend) {                    
                    isend = true;                    
                    for (k = -1; k <= 1; k++) {
                        for (l = -1; l <= 1; l++) {                            
                            if ((k==0) && (l == 0)) {
                                /* center pixel */
                                continue;                            
                            }
                            idx = (cur_i+k) + (cur_j+l)*R;
                        
                            if ((visited[idx] == 0) && (edgemap_edgeid[idx] == edgeid)) {
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
                
                /* walk through the whole segment the other way and determine length of edge */                
                isend = false;
                v_i = cur_i;
                v_j = cur_j;
                edgelen = 1;
                minptid = (unsigned int) edgemap_allptid[v_i+v_j*R];
                visited2[v_i+v_j*R] = 1;                
                while (!isend) {                                       
                    isend = true;                    
                    for (k = -1; k <= 1; k++) {
                        for (l = -1; l <= 1; l++) {                            
                            if ((k==0) && (l == 0)) {
                                /* center pixel */
                                continue;
                            }
                            
                            idx = (v_i+k) + (v_j+l)*R;
                            if ((visited2[idx] == 0) && (edgemap_edgeid[idx] == edgeid)) {
                                /* update idx */
                                visited2[idx] = 1;
                                if (((unsigned int)(edgemap_allptid[idx])) < minptid) {
                                    minptid = (unsigned int)(edgemap_allptid[idx]);
                                }
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
                }              
                
//                 mexPrintf("Edgelen: %d\n",edgelen);
                
                /* allocate adjacency matrix just for this edge */
                adjacency = (double *) mxMalloc((edgelen*edgelen) * sizeof(double));
                for (int a = 0; a < edgelen; a++) {
                    for (int b = 0; b < edgelen; b++) {
                        adjacency[a+b*edgelen] = 0;
                    }
                }
                
                
                /* walk through the whole segment the other way */                
                isend = false;
                v_i = cur_i;
                v_j = cur_j;
                visited3[v_i+v_j*R] = 1;                
                while (!isend) {                   
                    /* get the pt id of the current location */
                    
                    center_ptid = (unsigned int) (edgemap_ptid[v_i+v_j*R]) - 1;
                    n1 = normals[v_i+v_j*R];
                    /* compute adjacency around this point */
                    for (k = -5; k <= 5; k++) {
                        for (l = -5; l <= 5; l++) {
                            if ((k==0) && (l == 0)) {
                                /* center pixel */
                                continue;
                            }
                             /* check to make sure idx is still in bound of image */
                            if ( ((v_i+k) < 0) || ((v_i+k) >= R) || ((v_j+l) < 0) || ((v_j+l) >= C) ) {
                                continue;
                            }
                            
                            idx = (v_i+k) + (v_j+l)*R;
                            /* check to see if the pixel belongs to the same edge*/
                            other_ptid = (unsigned int) (edgemap_ptid[idx]) - 1;
                            if ((edgemap_edgeid[idx] == edgeid) && ((abs(center_ptid - other_ptid)) <= 5)){
                                /* idx of other point id on the edge */
                                idx_adj1 = center_ptid + other_ptid * edgelen;
                                idx_adj2 = other_ptid + center_ptid * edgelen;
                                if (adjacency[idx_adj1] != 0) {
                                    continue;
                                }
                                
                                /* otherwise compute adjacency */
                                d = sqrt(pow(double(k),2) + pow(double(l),2));
                                v12 = atan2(k,l);
                                n2 = normals[idx];
//                                 mexPrintf("n1=%0.2f, n2=%0.2f, v12=%0.2f\n",n1,n2,v12);
//                                 mexPrintf("%0.4f, %0.4f, %0.4f\n", normaldiff(n1,n2), fabs(PI/2 - normaldiff(n1,v12)), fabs(PI/2 - normaldiff(n2,v12)));
//                                 mexPrintf("%0.4f, %0.4f, %0.4f\n", (pow(normaldiff(n1,n2),2), pow(fabs(PI/2 - normaldiff(n1,v12)),2), pow(fabs(PI/2 - normaldiff(n2,v12)),2)));
//                                 mexPrintf("%0.4f\n", (2*pow(PI/18,2)));
                                adjscore = ( 13.5 - (pow(normaldiff(n1,n2),2) + pow(fabs(PI/2 - normaldiff(n1,v12)),2) + pow(fabs(PI/2 - normaldiff(n2,v12)),2)) ) / (2*pow(PI/18,2));
                                adjacency[idx_adj1] = adjscore;
                                adjacency[idx_adj2] = adjscore;
//                                 mexPrintf("(%d,%d)->(%d,%d): %0.2f\n", v_i, v_j, v_i+k, v_j+l, adjacency[idx_adj1]);
                            }
                            
                        }
                    }
                    
                    /* move to next position */
                    isend = true;                    
                    for (k = -1; k <= 1; k++) {
                        for (l = -1; l <= 1; l++) {                            
                            if ((k==0) && (l == 0)) {
                                /* center pixel */
                                continue;
                            }
                            
                            idx = (v_i+k) + (v_j+l)*R;
                            if ((visited3[idx] == 0) && (edgemap_edgeid[idx] != 0)) {
                                /* update idx */
                                visited3[idx] = 1;
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
                
//                 /* output to screen */
//                 for (int a = 0; a < edgelen; a++) {
//                     for (int b = 0; b < edgelen; b++) {
//                         mexPrintf("%0.2f ", adjacency[a+b*edgelen]);
//                     }
//                     mexPrintf("\n");
//                 }
                
                /* copy adjacency matrix into sparse matrix */
                /* columns */
//                 mexPrintf("edgeid: %d nzmax: %d, minptid: %d, edgelen: %d\n",edgeid, nzmax, minptid,edgelen);
                for (int b = 0; b < edgelen; b++) {
                    l = minptid + b - 1;
                    /* first element in this column */
                    jc[l] = spidx;
                    /* rows */
                    for (int a = 0; a < edgelen; a++) {
                        k = minptid + a - 1;
                        /* copy data into sparse matrix */
                        adjscore = adjacency[a+b*edgelen];
                        if (adjscore != 0) {
                            pr[spidx] = adjscore;
                            ir[spidx] = k;
                            spidx++; 
//                             mexPrintf("%d\n",spidx);
                        }
                    }
                }
                
//                 /* free the memory */
                mxFree(adjacency);
//                 for(int b = minptid + edgelen - 1; b <= num_edges; b++) {
//                     jc[b] = spidx;
//                 }
//                 return;

            }
        }
    }    

    jc[num_edgepts] = spidx;
    
    
        
}
