#!/bin/bash

# Setup CMake build location
mkdir build
cd build

# Configure, build, test, and install.
if [ "$(uname)" == "Linux" ];
then
    # Stop Boost from using libquadmath.
    export CXXFLAGS="${CXXFLAGS} -DBOOST_MATH_DISABLE_FLOAT128"
fi
cmake -DCMAKE_PREFIX_PATH=${PREFIX} \
      -DCPU_ONLY=ON \
      -DBLAS="open" \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -Dpython_version=$PY_VER \
      -DBUILD_docs=OFF \
      -DPYTHON_EXECUTABLE="${PREFIX}/bin/python" \
      -DNUMPY_INCLUDE_DIR="${SITE_PKGS}/numpy/core/include" \
      -DNUMPY_VERSION=${NPY_VER}  \
      ..

make -j${CPU_COUNT}
make install

# Python installation is non-standard. So, we're fixing it.
mv "${PREFIX}/python/caffe" "${SP_DIR}/"
for FILENAME in $( cd "${PREFIX}/python/" && find . -name "*.py" | sed 's|./||' );
do
    chmod +x "${PREFIX}/python/${FILENAME}"
    cp "${PREFIX}/python/${FILENAME}" "${PREFIX}/bin/${FILENAME//.py}"
done
rm -rf "${PREFIX}/python/"
