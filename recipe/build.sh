#!/bin/bash

set -ex

if [[ ${blas_impl} == openblas ]]; then
    BLAS=open
else
    BLAS=mkl
fi

cp $RECIPE_DIR/Makefile Makefile.config

# there's a math error associated with MKL seemingly
# https://github.com/BVLC/caffe/issues/4083#issuecomment-227046096
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

make all BLAS=$BLAS ANACONDA_HOME=$PREFIX CUSTOM_CXX=$GXX VERBOSE=1 -j${CPU_COUNT}
make pycaffe -j${CPU_COUNT}
make distribute

# Python installation is non-standard. So, we're fixing it.
for f in distribute/bin/*.bin; do mv $f distribute/bin/`basename $f .bin`; done; 
cp -r distribute/bin ${PREFIX}/
cp -r distribute/include ${PREFIX}/
cp -r distribute/lib ${PREFIX}/

mv distribute/python/caffe "${SP_DIR}/"
for FILENAME in $( cd "distribute/python/" && find . -name "*.py" | sed 's|./||' );
do
    chmod +x "distribute/python/${FILENAME}"
    cp "distribute/python/${FILENAME}" "distribute/bin/${FILENAME//.py}"
done

if [[ -d "distribute/lib64" ]]; then
    mv distribute/lib64/* ${PREFIX}/lib/
fi
