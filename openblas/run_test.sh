#! /usr/bin/env bash

LDFLAGS="-Wl,-rpath,${CONDA_PREFIX}/lib -L${CONDA_PREFIX}/lib ${LDFLAGS}"

env

echo "
#include <f77blas.h>

int main(int argc, const char ** argv) {
  // checking the values actually occurs during building. We're just checking
  // linking here
  int i=0;
  int N=4,incX=0,incY=0;
  double x1[]={1.0,3.0,5.0,7.0};
  double y1[]={2.0,4.0,6.0,8.0};
  double x2[]={1.0,3.0,5.0,7.0};
  double y2[]={2.0,4.0,6.0,8.0};

  BLASFUNC(dswap)(&N,x1,&incX,y1,&incY);
  return 0;
}
" > test.c

${CC} ${LDFLAGS} ${CFLAGS} -lopenblas -lgfortran -I "${CONDA_PREFIX}/include" test.c -o test
./test
