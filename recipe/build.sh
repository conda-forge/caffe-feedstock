#!/bin/bash

set -ex

# Setup CMake build location
# mkdir build && cd build

# Configure, build, test, and install.
#if [ "$(uname)" == "Linux" ]; then
    # Stop Boost from using libquadmath.
#    export CXXFLAGS="${CXXFLAGS} -D BOOST_MATH_DISABLE_FLOAT128"
#fi

# fix issue with linker when using gcc 7.3.0
#if [[ ${target_platform} =~ .*linux.* ]]; then
#    export LDFLAGS="${LDFLAGS} -L${STDLIB_DIR} -lboost_python -Wl,-rpath-link,${PREFIX}/lib"
#castingfi

if [[ ${blas_impl} == openblas ]]; then
    BLAS=open
else
    BLAS=mkl
fi

cp $RECIPE_DIR/Makefile Makefile.config

#cmake -D CPU_ONLY=1 \
#      -D BLAS="${BLAS}" \
#      -D CMAKE_INSTALL_PREFIX="${PREFIX}" \
#      -D NUMPY_INCLUDE_DIR="${SP_DIR}/numpy/core/include" \
#      -D NUMPY_VERSION=${NPY_VER} \
#      -D PYTHON_EXECUTABLE="${PREFIX}/bin/python" \
#      -D BUILD_docs="OFF" \
#      -D Boost_INCLUDE_DIRS="${PREFIX}/include/boost" \
#      -D Boost_LIBRARIES="${PREFIX}/lib" \
#      -D BOOST_LIBRARYDIR="${PREFIX}/lib" \
#      -D Boost_NO_BOOST_CMAKE=TRUE \
#      -D Boost_NO_SYSTEM_PATHS=TRUE \
#      -D BOOST_ROOT:PATHNAME=$PREFIX \
#      -D Boost_LIBRARY_DIRS:FILEPATH=${PREFIX}/lib \
#      -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
#      -DPYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
#      -DMKL_INCLUDE_DIR="${PREFIX}/include" \
#      -DMKL_RT_LIBRARY="${PREFIX}/lib" \
#      ${SRC_DIR}
# make -j${CPU_COUNT}
    #   -D Boost_NO_BOOST_CMAKE=TRUE \
    #   -D Boost_NO_SYSTEM_PATHS=TRUE \
    #   -D BOOST_ROOT:PATHNAME=$PREFIX \
    #   -D Boost_LIBRARY_DIRS:FILEPATH=${PREFIX}/lib \

# there's a math error associated with MKL seemingly
# https://github.com/BVLC/caffe/issues/4083#issuecomment-227046096
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

ls $PREFIX/lib
echo
ls $PREFIX/include
echo

make all BLAS=$BLAS ANACONDA_HOME=$PREFIX CUSTOM_CXX=$GXX VERBOSE=1
make pycaffe
make distribute

ls build
ls distribute
ls distribute/proto
ls distribute/bin
ls distribute/lib
ls distribute/include

# Python installation is non-standard. So, we're fixing it.
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
