#!/bin/bash

set -ex

# Setup CMake build location
mkdir build && cd build

# Configure, build, test, and install.
if [ "$(uname)" == "Linux" ]; then
    # Stop Boost from using libquadmath.
    export CXXFLAGS="${CXXFLAGS} -D BOOST_MATH_DISABLE_FLOAT128"
fi

# fix issue with linker when using gcc 7.3.0
if [[ ${target_platform} =~ .*linux.* ]]; then
    export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,${PREFIX}/lib"
fi

if [[ ${blas_impl} == openblas ]]; then
    BLAS=open
else
    BLAS=mkl
fi

cmake -D CPU_ONLY=1 \
      -D BLAS="${BLAS}" \
      -D CMAKE_INSTALL_PREFIX="${PREFIX}" \
      -D NUMPY_INCLUDE_DIR="${SP_DIR}/numpy/core/include" \
      -D NUMPY_VERSION=${NPY_VER} \
      -D PYTHON_EXECUTABLE="${PREFIX}/bin/python" \
      -D BUILD_docs="OFF" \
      -D Boost_INCLUDE_DIRS="${PREFIX}/include" \
      -D Boost_LIBRARIES="${PREFIX}/lib" \
      -D Boost_NO_BOOST_CMAKE=TRUE \
      -D Boost_NO_SYSTEM_PATHS=TRUE \
      -D BOOST_ROOT:PATHNAME=$PREFIX \
      -D Boost_LIBRARY_DIRS:FILEPATH=${PREFIX}/lib \
      ${SRC_DIR}
make -j${CPU_COUNT}
    #   -D Boost_NO_BOOST_CMAKE=TRUE \
    #   -D Boost_NO_SYSTEM_PATHS=TRUE \
    #   -D BOOST_ROOT:PATHNAME=$PREFIX \
    #   -D Boost_LIBRARY_DIRS:FILEPATH=${PREFIX}/lib \

# there's a math error associated with MKL seemingly
# https://github.com/BVLC/caffe/issues/4083#issuecomment-227046096
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
make -j${CPU_COUNT} runtest

make install

# Python installation is non-standard. So, we're fixing it.
mv "${PREFIX}/python/caffe" "${SP_DIR}/"
for FILENAME in $( cd "${PREFIX}/python/" && find . -name "*.py" | sed 's|./||' );
do
    chmod +x "${PREFIX}/python/${FILENAME}"
    cp "${PREFIX}/python/${FILENAME}" "${PREFIX}/bin/${FILENAME//.py}"
done
rm -rf "${PREFIX}/python/"

if [[ -d "${PREFIX}/lib64" ]]; then
    mv ${PREFIX}/lib64/* ${PREFIX}/lib/
    rmdir ${PREFIX}/lib64
fi
